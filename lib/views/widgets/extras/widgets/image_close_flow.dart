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

  static const _orange = Color(0xFFFF8000);
  static const _vert = Color(0xFF19A015);
  static const _blue = Color(0xFF3887E0);
  static const _dark = Color(0xFF1E293B);

  @override
  void initState() {
    super.initState();
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
        setState(() => _images
            .addAll(response.files!.map((f) => File(f.path))));
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
        setState(() =>
            _images.addAll(picked.map((x) => File(x.path))));
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
      _showSnack(
          'Saisissez le nombre de participants estimé.', Colors.red);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: _vert.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.cloud_upload_outlined,
                        color: _vert, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Enregistrer les photos ?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _dark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Les photos et le nombre de participants seront envoyés au serveur.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx, false),
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6FA),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: const Color(0xFFEEF0F3)),
                        ),
                        child: const Center(
                          child: Text(
                            'Annuler',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: _dark,
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
                        height: 46,
                        decoration: BoxDecoration(
                          color: _vert,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: _vert.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Enregistrer',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
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
            'Photos et participants enregistrés !', _vert);
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
        content: Row(
          children: [
            Icon(
              color == Colors.red
                  ? Icons.error_outline_rounded
                  : Icons.check_circle_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(msg,
                style: const TextStyle(fontSize: 13.5))),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExtrasProvider>();
    final seance = provider.selectedSeance;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: CustomScrollView(
        slivers: [
          // ── AppBar ──
          SliverAppBar(
            pinned: true,
            backgroundColor: _orange,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
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
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  seance.nom,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // ── Contenu ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Étape 1 : Photos ──
                  _sectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _StepHeader(
                          number: '1',
                          title: 'Photos de la liste de présence',
                          color: _blue,
                        ),
                        const SizedBox(height: 16),

                        // Grille photos
                        if (_images.isNotEmpty) ...[
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                                      color: const Color(0xFFF5F6FA),
                                      borderRadius:
                                      BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFFEEF0F3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.add_rounded,
                                      color: Colors.grey[400],
                                      size: 28,
                                    ),
                                  ),
                                );
                              }
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(12),
                                    child: Image.file(
                                      _images[i],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 5, right: 5,
                                    child: GestureDetector(
                                      onTap: () => setState(
                                              () => _images.removeAt(i)),
                                      child: Container(
                                        width: 22, height: 22,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFE24B4A),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          size: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 14),
                        ],

                        // Boutons caméra / galerie
                        Row(
                          children: [
                            Expanded(
                              child: _PhotoButton(
                                icon: Icons.camera_alt_outlined,
                                label: 'Caméra',
                                color: _blue,
                                onTap: _pickCamera,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _PhotoButton(
                                icon: Icons.grid_view_rounded,
                                label: 'Galerie',
                                color: _blue,
                                onTap: _pickGallery,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Champ légende
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: const Color(0xFFEEF0F3), width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 4),
                          child: Row(
                            children: [
                              Icon(Icons.notes_rounded,
                                  size: 16, color: Colors.grey[400]),
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
                                    const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Étape 2 : Participants ──
                  _sectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _StepHeader(
                          number: '2',
                          title: 'Nombre de participants estimé',
                          color: _orange,
                        ),
                        const SizedBox(height: 16),

                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: const Color(0xFFEEF0F3), width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 14),
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.baseline,
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
                                    fontSize: 40,
                                    fontWeight: FontWeight.w800,
                                    color: _dark,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: '0',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[300],
                                      fontSize: 40,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              Text(
                                'participants',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Chiffre approximatif basé sur les listes physiques.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Bouton enregistrer ──
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: provider.isSaving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _vert,
                        disabledBackgroundColor: Colors.grey[200],
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: provider.isSaving
                          ? const SizedBox(
                        width: 22, height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload_outlined,
                              color: Colors.white, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Enregistrer',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEEF0F3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: child,
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
          width: 28, height: 28,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}

class _PhotoButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _PhotoButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}