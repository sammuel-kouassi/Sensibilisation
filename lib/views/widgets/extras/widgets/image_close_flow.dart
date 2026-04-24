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
  void dispose() {
    _nbController.dispose();
    _legendeController.dispose();
    super.dispose();
  }

  // ✅ Fix écran blanc caméra : utiliser ImageSource.camera avec try/catch
  Future<void> _pickCamera() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (picked != null && mounted) {
        setState(() => _images.add(File(picked.path)));
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

  // ✅ Dialog de confirmation avant de clore
  Future<void> _save() async {
    if (_images.isEmpty) {
      _showSnack('Ajoutez au moins une image avant de clore.', Colors.red);
      return;
    }
    if (_nbController.text.isEmpty) {
      _showSnack('Saisissez le nombre de participants estimé.', Colors.red);
      return;
    }

    // --- CONFIRMATION ---
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.lock_outline, color: Color(0xFF21951D), size: 22),
            SizedBox(width: 10),
            Text('Clore la séance ?'),
          ],
        ),
        content: const Text(
          'Cette action est irréversible. La séance sera marquée comme terminée.',
          style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('ANNULER', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF21951D),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('OUI, CLORE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final provider = context.read<ExtrasProvider>();
    final success = await provider.saveImagesAndClose(
      imagePaths: _images.map((f) => f.path).toList(),
      legende: _legendeController.text,
      nbParticipants: int.tryParse(_nbController.text) ?? 0,
    );

    if (mounted) {
      if (success) {
        _showSnack('✅ Séance clôturée avec succès !', const Color(0xFF21951D));
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        _showSnack('Erreur lors de la clôture.', Colors.red);
      }
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color, behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExtrasProvider>();
    final seance = provider.selectedSeance;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          seance?.nom ?? '',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ÉTAPE 1
            _StepHeader(number: '1', title: 'Photos de la liste', color: const Color(0xFF2196F3)),
            const SizedBox(height: 12),

            if (_images.isNotEmpty) ...[
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8,
                ),
                itemCount: _images.length,
                itemBuilder: (_, i) => Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(_images[i], fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 4, right: 4,
                      child: GestureDetector(
                        onTap: () => setState(() => _images.removeAt(i)),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          child: const Icon(Icons.close, size: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            Row(
              children: [
                Expanded(child: _PhotoButton(icon: Icons.camera_alt_outlined, label: 'Caméra', onTap: _pickCamera)),
                const SizedBox(width: 10),
                Expanded(child: _PhotoButton(icon: Icons.photo_library_outlined, label: 'Galerie', onTap: _pickGallery)),
              ],
            ),

            const SizedBox(height: 12),
            TextField(
              controller: _legendeController,
              decoration: InputDecoration(
                hintText: 'Légende (optionnel)',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.15))),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),

            const SizedBox(height: 32),

            // ÉTAPE 2
            _StepHeader(number: '2', title: 'Nombre estimé de participants', color: const Color(0xFFFF9500)),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.withOpacity(0.15)),
              ),
              child: TextField(
                controller: _nbController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: TextStyle(color: Colors.grey[300], fontSize: 28),
                  border: InputBorder.none,
                  suffixText: 'pers.',
                  suffixStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: provider.isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF21951D),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: provider.isSaving
                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('Clore la séance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
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
  const _StepHeader({required this.number, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28, height: 28,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(child: Text(number, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
        ),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }
}

class _PhotoButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _PhotoButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2196F3).withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF2196F3), size: 24),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF2196F3), fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}