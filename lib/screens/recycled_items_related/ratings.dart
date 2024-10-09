import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:waste_wise/common_widgets/background_image_wrapper.dart';
import 'package:waste_wise/common_widgets/custom_app_bar.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  // A list to store reviews, including the name of the user who added the review
  final List<Map<String, dynamic>> _reviews = [
    {
      'rating': 5,
      'comment': 'Great product!',
      'username': 'Alice',
      'isHardcoded': true,
    },
    {
      'rating': 4,
      'comment': 'Really liked it!',
      'username': 'Bob',
      'isHardcoded': true,
    },
    {
      'rating': 3,
      'comment': 'It was okay.',
      'username': 'Charlie',
      'isHardcoded': true,
    },
  ];

  // Function to add a new review
  void _addReview(int rating, String comment) {
    setState(() {
      // Add new reviews at the top of the list
      _reviews.insert(0, {
        'rating': rating,
        'comment': comment,
        'username':
            'New User', // Assuming this is the current user for new reviews
        'isHardcoded': false,
      });
    });
  }

  // Function to delete a review
  void _deleteReview(int index) {
    setState(() {
      _reviews.removeAt(index);
    });
  }

  // Function to show a dialog for adding a new review
  Future<void> _showAddReviewDialog() async {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _commentController = TextEditingController();
    int _rating = 1;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a Review'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Rating input (Dropdown)
                DropdownButtonFormField<int>(
                  value: _rating,
                  decoration: const InputDecoration(labelText: 'Rating'),
                  items: List.generate(5, (index) {
                    return DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text('${index + 1} stars'),
                    );
                  }),
                  onChanged: (value) {
                    _rating = value ?? 1;
                  },
                ),
                const SizedBox(height: 20),
                // Review input
                TextFormField(
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.top,
                  controller: _commentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Comment',
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior
                        .always, // Ensure label floats above
                    contentPadding: EdgeInsets.fromLTRB(
                        12, 20, 12, 12), // Adjust padding to raise label
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a comment.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addReview(_rating, _commentController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(
          name: 'Reviews',
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _reviews.length,
                  itemBuilder: (context, index) {
                    final review = _reviews[index];
                    final bool isHardcoded = review['isHardcoded'] ??
                        false; // Safely access isHardcoded

                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review['username'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            // Replacing the old star Row with RatingStars widget
                            RatingStars(
                              value: review['rating']
                                  .toDouble(), // Assuming rating is an int
                              starBuilder: (index, color) => Icon(
                                Icons.star,
                                color: color,
                                size: 22,
                              ),
                              starCount: 5,
                              starSize: 22,
                              maxValue: 5,
                              starSpacing: 1,
                              maxValueVisibility: false,
                              valueLabelVisibility: false,
                              valueLabelColor:
                                  const Color.fromARGB(255, 113, 113, 113),
                              animationDuration:
                                  const Duration(milliseconds: 1000),
                              valueLabelPadding: const EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 8),
                              valueLabelMargin: const EdgeInsets.only(right: 8),
                              starOffColor: const Color(0xffe7e8ea),
                              starColor: const Color.fromARGB(255, 255, 230, 0),
                            ),
                          ],
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(review['comment']),
                        ),
                        trailing: !isHardcoded
                            ? IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteReview(index);
                                },
                              )
                            : null, // Only allow deletion for non-hardcoded reviews
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 12.0),
                ),
                onPressed: _showAddReviewDialog,
                child: const Text(
                  'Add Review',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
