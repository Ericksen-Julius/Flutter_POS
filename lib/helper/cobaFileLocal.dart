import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatefulWidget {
  final String imagePath; // Server image URL
  final String localPath; // Local file path fallback

  ImageWidget({required this.imagePath, required this.localPath});

  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  bool _timeout = false; // Flag to handle timeout

  @override
  void initState() {
    super.initState();
    // Start the timeout timer
    _startTimeout();
  }

  void _startTimeout() {
    Timer(Duration(seconds: 5), () {
      if (!mounted) return;
      setState(() {
        _timeout = true; // Switch to fallback after 5 seconds
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _timeout
        ? _loadLocalImageFallback() // Show fallback after timeout
        : CachedNetworkImage(
            imageUrl: widget.imagePath,
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: Container(
                width: double.infinity,
                height: 100, // Set the height as per your requirement
                padding: EdgeInsets.all(10.0), // Add padding
                alignment: Alignment.center, // Center the loading indicator
                child: CircularProgressIndicator(), // Loading indicator
              ),
            ),
            errorWidget: (context, url, error) => _loadLocalImageFallback(),
          );
  }

  // Fallback method to load the local image or default asset image
  Widget _loadLocalImageFallback() {
    return Image.file(
      File(widget.localPath),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        height: 100, // Maintain consistent height
        padding: EdgeInsets.all(10.0), // Add padding
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/default_image.jpg'), // Final fallback
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
