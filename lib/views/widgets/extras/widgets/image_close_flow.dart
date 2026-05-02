import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../providers/extras_provider.dart';

class ImageCloseFlow extends StatefulWidget {
  const ImageCloseFlow({super.key});

  @override
  State<ImageCloseFlow> createState() => _ImageCloseFlowState();
}

class _ImageCloseFlowState extends State<ImageCloseFlow> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nbController = TextEditingController();
  final TextEditingController _legendeController = TextEditingController();
  List<File> _images = [];

  @override
  void initState() {
    super.initState();
    // Fix écran blanc Android : récupère l'image si l'activity
    // a été détruite pendant l'ouverture de la caméra
    _retrieveLostData();
  }

  @override
  void dispose() {
    _nbController.dispose();
    _legendeController.dispose();
    super.dispose();
  }

  Future<void> _retrieveLostData() async {
    try {
      final response = await _picker.retrieveLostData();
      if (response.isEmpty || !mounted) return;

      if (response.file != null) {
        setState(() => _images.add(File(response.file!.path)));
      } else if (response.files != null && response.files!.isNotEmpty) {
        setState(() => _images.addAll(response.files!.map((f) => File(f.path))));
      }
    } catch (e) {
      debugPrint('retrieveLostData erreur : $e');
    }
  }

  Future<void> _pickCamera() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (picked != null && mounted) {
        setState(() => _images.add(File(picked.path)));
      } else if (picked == null && mounted) {
        await _retrieveLostData();
      }
    } catch (e) {
      debugPrint('Erreur caméra : $e');
      if (mounted) _showSnack('Impossible d\'accéder à la caméra.', Colors.red);
    }
  }

  Future<void> _pickGallery() async {
    try {
      final picked = await _picker.pickMultiImage(imageQuality: 75);
      if (picked.isNotEmpty && mounted) {
        setState(() => _images.addAll(picked.map((x) => File(x.path))));
      }
    } catch (e) {
      debugPrint('Erreur galerie : $e');
    }
  }

  Future<void> _save() async {
    if (_images.isEmpty) {
      _showSnack('Ajoutez au moins une image.', Colors.red);
      return;
    }
    if (_nbController.text.isEmpty) {
      _showSnack('Saisissez le nombre de participants estimé.', Colors.red);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Color(0xFF19A015),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Enregistrer les photos et le nombre estimé de participants ?',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Les photos seront envoyées au serveur.',
                style: TextStyle(fontSize: 13.5, color: Colors.black54, height: 1.55),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx, false),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Annuler',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx, true),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF19A015),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Enregistrer',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed != true) return;

    final provider = context.read<ExtrasProvider>();
    final success = await provider.saveImagesAndParticipants(
      imagePaths: _images.map((f) => f.path).toList(),
      legende: _legendeController.text,
      nbParticipants: int.tryParse(_nbController.text) ?? 0,
    );

    if (mounted) {
      if (success) {
        _showSnack(
          'Photos et participants enregistrés avec succès !',
          const Color(0xFF19A015),
        );
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        _showSnack('Erreur lors de l\'enregistrement.', Colors.red);
      }
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontSize: 13.5)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExtrasProvider>();
    final seance = provider.selectedSeance;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.withOpacity(0.18)),
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  size: 20,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
        title: seance == null
            ? const SizedBox.shrink()
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Photos & participants',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              seance.nom,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Divider(
            height: 0.5,
            thickness: 0.5,
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const _StepHeader(
              number: '1',
              title: 'Photos de la liste de présence',
              color: Color(0xFF3887E0),
            ),
            const SizedBox(height: 14),

            if (_images.isNotEmpty) ...[
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _images.length + 1,
                itemBuilder: (_, i) {
                  if (i == _images.length) {
                    return GestureDetector(
                      onTap: _pickCamera,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.25),
                          ),
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.grey,
                          size: 24,
                        ),
                      ),
                    );
                  }
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(_images[i], fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () => setState(() => _images.removeAt(i)),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE24B4A),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
            ],

            Row(
              children: [
                Expanded(
                  child: _PhotoButton(
                    icon: Icons.camera_alt_outlined,
                    label: 'Caméra',
                    onTap: _pickCamera,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _PhotoButton(
                    icon: Icons.grid_view_rounded,
                    label: 'Galerie',
                    onTap: _pickGallery,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.withOpacity(0.15)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.notes_rounded, size: 16, color: Colors.grey[400]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _legendeController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Légende (optionnel)',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── DIVIDER ──
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Divider(
                color: Colors.grey.withOpacity(0.15),
                thickness: 0.5,
              ),
            ),

            // ── ÉTAPE 2 ──
            const _StepHeader(
              number: '2',
              title: 'Nombre de participants estimé',
              color: Color(0xFFFF9500),
            ),
            const SizedBox(height: 14),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.withOpacity(0.15)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nbController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  Text(
                    'participants',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                'Chiffre approximatif basé sur les listes physiques.',
                style: TextStyle(fontSize: 11, color: Colors.grey[400]),
              ),
            ),

            const SizedBox(height: 36),

            // ── CTA ──
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: provider.isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF19A015),
                  disabledBackgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: provider.isSaving
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Enregistrer',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _StepHeader extends StatelessWidget {
  final String number;
  final String title;
  final Color color;
  const _StepHeader({
    required this.number,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}


class _PhotoButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _PhotoButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF3887E0), size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF3887E0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}