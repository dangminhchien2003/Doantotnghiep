import 'package:flutter/material.dart';
import 'package:booking_petcare/Model/Blog/BlogModel.dart';

class BlogDetail extends StatelessWidget {
  final BlogModel blog;

  const BlogDetail({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          blog.tieuDe,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0, // Không có đổ bóng dưới app bar
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Thêm hành động chia sẻ ở đây
              print("Chia sẻ bài viết");
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // Thêm hành động thích bài viết ở đây
              print("Yêu thích bài viết");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            // Hiển thị hình ảnh
            child: ClipRRect(
              // borderRadius: BorderRadius.circular(10),
              child: Image.network(
                blog.hinhAnh,
                fit: BoxFit.cover,
                height: 220,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề bài viết
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    blog.tieuDe,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                // Nội dung bài viết
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    blog.noiDung,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ),

                // Thông tin ngày tạo và cập nhật
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        'Cập nhật: ${blog.updatedAt}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Các nút hành động (Like, Share)
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Nút Like
                      ElevatedButton.icon(
                        onPressed: () {
                          // Thêm hành động Like ở đây
                          print("Liked the post");
                        },
                        icon: const Icon(
                          Icons.thumb_up_alt_outlined,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Thích',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                      // Nút Share
                      ElevatedButton.icon(
                        onPressed: () {
                          // Thêm hành động chia sẻ ở đây
                          print("Shared the post");
                        },
                        icon: const Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Chia sẻ',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
