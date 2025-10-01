// Data model
class UploadResult{
    final bool success;
    final int statusCode;
    final String? url;
    final String? message;
    const UploadResult({
        required this.success,
        required this.statusCode,
        this.url,
        this.message,
    });
}
