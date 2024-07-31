import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:link_shortener_mobile/Models/DTO/ShortLinksResponseDTO.dart';
import 'package:link_shortener_mobile/Models/ShortLink.dart';
import 'package:link_shortener_mobile/Providers/AuthProvider.dart';
import 'package:link_shortener_mobile/Providers/ShortLinkProvider.dart';
import 'package:provider/provider.dart';

const color1 = Color(0xffeabfff);
const color2 = Color(0xff3c005a);
const color3 = Color(0xff800080);
const color4 = Color(0xffd580ff);
const colorBackground = Color(0xfffff3fd);

const colorText1 = Color(0xff2E384D);
const colorText2 = Color(0xff91A1B4);

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ShortLinkProvider>(context, listen: false)
          .getUserShortLinks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text(
          'Link Shortener',
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 32,
              color: colorText1,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: const CircleAvatar(
                backgroundImage: AssetImage('assets/icon.png'),
              )),
          IconButton(
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  Provider.of<AuthProvider>(context, listen: false)
                      .logout(context);
                });
              },
              icon: const Icon(
                Icons.logout,
                color: color2,
              ))
        ],
      ),
      body: Consumer<ShortLinkProvider>(builder: (context, value, child) {
        if (value.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: color3,
              strokeWidth: 8,
            ),
          );
        }

        if (value.errorDto != null) {
          final error = value.errorDto!.error_message;
          return Center(
            child: Text(
              'Bir hata meydana geldi\n$error',
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.roboto(textStyle: const TextStyle(fontSize: 24)),
            ),
          );
        }

        final dto = value.response as ShortLinksResponseDTO;

        final totalLinkCount = dto.totalCount;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  InfoWidget(
                    icon: Icons.link,
                    countText: '$totalLinkCount',
                    infoText: 'Oluşturulan Link Sayısı',
                    iconEnd: true,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Kısa Linkler',
                style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: colorText1,
                  height: 1,
                )),
              ),
            ),
            const Divider(
              color: color2,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: dto.shortLinks!.length,
                  itemBuilder: (BuildContext context, int index) {
                    ShortLink link = dto.shortLinks![index];
                    return TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder()),
                        child: LinkItem(
                          name: link.name!,
                          url: link.redirectUrl!,
                        ));
                  }),
            )
          ],
        );
      }),
    );
  }
}

class LinkItem extends StatelessWidget {
  final String name;
  final String url;

  const LinkItem({super.key, required this.name, required this.url});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.link,
                    size: 32,
                    color: color3,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(fontSize: 26),
                          height: 1.2,
                          color: colorText1),
                    ),
                    Text(
                      url.length <= 30 ? url : '${url.substring(0, 30)}...',
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontSize: 16,
                              color: colorText2,
                              fontStyle: FontStyle.italic)),
                    )
                  ],
                )
              ],
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_horiz,
                  color: color3,
                ))
          ]),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            thickness: 0.5,
            color: colorText1,
          ),
        )
      ],
    );
  }
}

class InfoWidget extends StatelessWidget {
  final String countText;
  final String infoText;
  final IconData icon;
  final bool iconEnd;

  const InfoWidget(
      {super.key,
      required this.countText,
      required this.infoText,
      required this.icon,
      this.iconEnd = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!iconEnd)
                  Icon(
                    icon,
                    size: 48,
                    color: color2,
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    countText,
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            color: colorText1,
                            fontSize: 56,
                            fontWeight: FontWeight.w300,
                            height: 1.2)),
                  ),
                ),
                if (iconEnd)
                  Icon(
                    icon,
                    size: 48,
                    color: color2,
                  ),
              ],
            ),
            Text(
              infoText,
              style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ],
    );
  }
}
