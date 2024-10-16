import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/image_cubit/image_cubit.dart';
import '../cubits/image_cubit/image_states.dart';

class ImageView extends StatelessWidget {
  const ImageView({super.key, this.autoPlay = false});
  final bool autoPlay;

  @override
  Widget build(BuildContext context) {
    int? currentIndex;
    return BlocBuilder<ImageCubit, ImageStates>(
      builder: (context, state) {
        final imageCubit = context.read<ImageCubit>();
        return Stack(
          children: [
            if (imageCubit.images.isNotEmpty)
              CarouselSlider.builder(
                itemCount: imageCubit.images.length,
                itemBuilder: (context, index, realIndex) {
                  currentIndex = index;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: FileImage(imageCubit.images[index]),
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  viewportFraction: 1,
                  height: MediaQuery.of(context).size.height * 0.5,
                  autoPlay: autoPlay,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(seconds: 2),
                  autoPlayCurve: Curves.easeInOut,
                ),
              ),
            if (imageCubit.images.isNotEmpty)
              GestureDetector(
                onTap: () {
                  imageCubit.deleteImage(currentIndex!);
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.pinkAccent.withOpacity(0.1),
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
