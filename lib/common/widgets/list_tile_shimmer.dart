import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListTileShimmer extends StatelessWidget {
  final int count;
  const ListTileShimmer({
    Key? key,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final base = count.isEven ? Colors.grey.withOpacity(.3) : Colors.grey.withOpacity(.2);
    final highlight = count.isEven ? Colors.grey.withOpacity(.4) : Colors.grey.withOpacity(.3);
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: ListView.builder(
        itemCount: count,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {},
            title: Container(
              width: 100,
              height: 20,
              color: highlight,
            ),
            subtitle: Container(
              width: 10,
              height: 20,
              color: base,
            ),
            leading: const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
