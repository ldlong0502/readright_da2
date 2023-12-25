import 'package:ebook/views/home/subject_ebook_widget.dart';
import 'package:flutter/material.dart';

import '../../models/genre.dart';
import '../../theme/theme_config.dart';
import '../../util/dialogs.dart';

class EbookSubject extends StatefulWidget {
  const EbookSubject({super.key, required this.genre});
  final Genre genre;
  @override
  State<EbookSubject> createState() => _EbookSubjectState();
}

class _EbookSubjectState extends State<EbookSubject> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: size.height / 7,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [ThemeConfig.lightAccent, ThemeConfig.fourthAccent],
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(child: Image.network(widget.genre.icon , height: 20,)),
                            const SizedBox(width: 10,),
                            Flexible(
                              child: Text(
                                widget.genre.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white,
                                    
                                    fontSize: 20,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child:  IconButton(
                                onPressed: () {
                                   Dialogs().showSetUpBottomDialog(context);
                                },
                                icon: const Icon(Icons.swap_vert_outlined , color: Colors.white,))
                      )
                    ),
                  ],
                ),
              )),
          Positioned(
            top: size.height * 0.12,
            left: 0,
            right: 0,
            bottom: 0 ,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              // child:  Column(
              //   children: [
              //     
                 
              //   ],
              // ),
              child:  SubjectEbookWidget(idGenre: widget.genre.id),
            ),
            
          ),
        ],
      ),
    );
  }
}
