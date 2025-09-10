import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConsultationChatWidget extends StatefulWidget {
  final Map<String, dynamic> expert;
  final String consultationId;

  const ConsultationChatWidget({
    super.key,
    required this.expert,
    required this.consultationId,
  });

  @override
  State<ConsultationChatWidget> createState() => _ConsultationChatWidgetState();
}

class _ConsultationChatWidgetState extends State<ConsultationChatWidget> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();

  bool _isRecording = false;
  bool _isTyping = false;
  String? _recordingPath;

  List<Map<String, dynamic>> _messages = [
    {
      "id": "1",
      "senderId": "expert_123",
      "senderName": "Dr. Rajesh Kumar",
      "message":
          "Hello! I've reviewed your crop images. I can see some early signs of leaf blight. Let me guide you through the treatment process.",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 5)),
      "type": "text",
      "isExpert": true,
    },
    {
      "id": "2",
      "senderId": "farmer_456",
      "senderName": "Ramesh Patel",
      "message": "Thank you doctor. What should I do immediately?",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 3)),
      "type": "text",
      "isExpert": false,
    },
    {
      "id": "3",
      "senderId": "expert_123",
      "senderName": "Dr. Rajesh Kumar",
      "message":
          "First, remove all affected leaves immediately. Then spray copper fungicide solution. I'll send you the exact mixture ratio.",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 2)),
      "type": "text",
      "isExpert": true,
    },
    {
      "id": "4",
      "senderId": "expert_123",
      "senderName": "Dr. Rajesh Kumar",
      "imageUrl":
          "https://images.pexels.com/photos/4503273/pexels-photo-4503273.jpeg",
      "message": "Here's the proper spraying technique",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 1)),
      "type": "image",
      "isExpert": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildChatHeader(context),
          Expanded(
            child: _buildMessagesList(context),
          ),
          _buildMessageInput(context),
        ],
      ),
    );
  }

  Widget _buildChatHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isOnline = widget.expert["isOnline"] as bool? ?? false;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: theme.textTheme.bodyLarge?.color,
              size: 24,
            ),
          ),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: widget.expert["profileImage"] as String? ?? "",
                  width: 10.w,
                  height: 10.w,
                  fit: BoxFit.cover,
                ),
              ),
              if (isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 2.5.w,
                    height: 2.5.w,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.surface,
                        width: 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.expert["name"] as String? ?? "Expert",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  isOnline ? "Online" : "Last seen recently",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isOnline
                        ? Colors.green
                        : theme.textTheme.bodySmall?.color
                            ?.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _startVideoCall,
            icon: CustomIconWidget(
              iconName: 'video_call',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: _startVoiceCall,
            icon: CustomIconWidget(
              iconName: 'call',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor.withValues(alpha: 0.5),
      ),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(4.w),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          final isExpert = message["isExpert"] as bool;
          final isMe = !isExpert;

          return _buildMessageBubble(context, message, isMe);
        },
      ),
    );
  }

  Widget _buildMessageBubble(
      BuildContext context, Map<String, dynamic> message, bool isMe) {
    final theme = Theme.of(context);
    final messageType = message["type"] as String? ?? "text";
    final timestamp = message["timestamp"] as DateTime;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CustomImageWidget(
                imageUrl: widget.expert["profileImage"] as String? ?? "",
                width: 8.w,
                height: 8.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 2.w),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: 70.w),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: isMe
                    ? AppTheme.lightTheme.primaryColor
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                border: !isMe ? Border.all(color: theme.dividerColor) : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (messageType == "image") ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: message["imageUrl"] as String? ?? "",
                        width: double.infinity,
                        height: 30.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (message["message"] != null &&
                        (message["message"] as String).isNotEmpty) ...[
                      SizedBox(height: 1.h),
                      Text(
                        message["message"] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isMe
                              ? Colors.white
                              : theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ] else if (messageType == "audio") ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'play_arrow',
                          color: isMe
                              ? Colors.white
                              : AppTheme.lightTheme.primaryColor,
                          size: 24,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Container(
                            height: 0.5.h,
                            decoration: BoxDecoration(
                              color: (isMe
                                      ? Colors.white
                                      : AppTheme.lightTheme.primaryColor)
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          message["duration"] as String? ?? "0:30",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isMe
                                ? Colors.white.withValues(alpha: 0.8)
                                : theme.textTheme.bodySmall?.color
                                    ?.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      message["message"] as String? ?? "",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isMe
                            ? Colors.white
                            : theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                  SizedBox(height: 0.5.h),
                  Text(
                    "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isMe
                          ? Colors.white.withValues(alpha: 0.7)
                          : theme.textTheme.bodySmall?.color
                              ?.withValues(alpha: 0.6),
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            SizedBox(width: 2.w),
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'person',
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          if (_isTyping) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              child: Row(
                children: [
                  Text(
                    "${widget.expert["name"]} is typing...",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  SizedBox(
                    width: 4.w,
                    height: 4.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
          Row(
            children: [
              IconButton(
                onPressed: _showAttachmentOptions,
                icon: CustomIconWidget(
                  iconName: 'attach_file',
                  color:
                      theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
                  size: 24,
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 2.h),
                          ),
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                      IconButton(
                        onPressed:
                            _isRecording ? _stopRecording : _startRecording,
                        icon: CustomIconWidget(
                          iconName: _isRecording ? 'stop' : 'mic',
                          color: _isRecording
                              ? Colors.red
                              : theme.textTheme.bodyLarge?.color
                                  ?.withValues(alpha: 0.7),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: _sendMessage,
                  icon: CustomIconWidget(
                    iconName: 'send',
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAttachmentOptions() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Send Attachment',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  context,
                  CustomIconWidget(
                    iconName: 'camera_alt',
                    color: Colors.blue,
                    size: 32,
                  ),
                  'Camera',
                  () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                _buildAttachmentOption(
                  context,
                  CustomIconWidget(
                    iconName: 'photo_library',
                    color: Colors.green,
                    size: 32,
                  ),
                  'Gallery',
                  () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                _buildAttachmentOption(
                  context,
                  CustomIconWidget(
                    iconName: 'location_on',
                    color: Colors.red,
                    size: 32,
                  ),
                  'Location',
                  () {
                    Navigator.pop(context);
                    _shareLocation();
                  },
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(
      BuildContext context, Widget icon, String label, VoidCallback onTap) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(color: theme.dividerColor),
            ),
            child: icon,
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: source);
      if (image != null) {
        _sendImageMessage(image.path);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await Permission.microphone.request().isGranted) {
        if (await _audioRecorder.hasPermission()) {
          await _audioRecorder.start(const RecordConfig(),
              path: 'recording.m4a');
          setState(() => _isRecording = true);
        }
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() => _isRecording = false);
      if (path != null) {
        _sendAudioMessage(path);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({
          "id": DateTime.now().millisecondsSinceEpoch.toString(),
          "senderId": "farmer_456",
          "senderName": "You",
          "message": text,
          "timestamp": DateTime.now(),
          "type": "text",
          "isExpert": false,
        });
        _messageController.clear();
      });
      _scrollToBottom();
      _simulateExpertResponse();
    }
  }

  void _sendImageMessage(String imagePath) {
    setState(() {
      _messages.add({
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
        "senderId": "farmer_456",
        "senderName": "You",
        "imageUrl":
            "https://images.pexels.com/photos/1595104/pexels-photo-1595104.jpeg",
        "message": "Crop image for analysis",
        "timestamp": DateTime.now(),
        "type": "image",
        "isExpert": false,
      });
    });
    _scrollToBottom();
    _simulateExpertResponse();
  }

  void _sendAudioMessage(String audioPath) {
    setState(() {
      _messages.add({
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
        "senderId": "farmer_456",
        "senderName": "You",
        "audioPath": audioPath,
        "duration": "0:15",
        "timestamp": DateTime.now(),
        "type": "audio",
        "isExpert": false,
      });
    });
    _scrollToBottom();
    _simulateExpertResponse();
  }

  void _shareLocation() {
    setState(() {
      _messages.add({
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
        "senderId": "farmer_456",
        "senderName": "You",
        "message": "📍 Farm Location: Lat 23.0225, Lng 72.5714",
        "timestamp": DateTime.now(),
        "type": "location",
        "isExpert": false,
      });
    });
    _scrollToBottom();
    _simulateExpertResponse();
  }

  void _simulateExpertResponse() {
    setState(() => _isTyping = true);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({
            "id": DateTime.now().millisecondsSinceEpoch.toString(),
            "senderId": "expert_123",
            "senderName": widget.expert["name"],
            "message":
                "Thank you for sharing. I'll analyze this and get back to you with recommendations shortly.",
            "timestamp": DateTime.now(),
            "type": "text",
            "isExpert": true,
          });
        });
        _scrollToBottom();
      }
    });
  }

  void _startVideoCall() {
    // Implement video call functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Starting video call...')),
    );
  }

  void _startVoiceCall() {
    // Implement voice call functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Starting voice call...')),
    );
  }
}
