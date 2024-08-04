import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:link_shortener_mobile/Core/HttpBase.dart';
import 'package:link_shortener_mobile/Models/DTO/ShortLinkLogsDTO.dart';
import 'package:link_shortener_mobile/Models/ShortLink.dart';
import 'package:link_shortener_mobile/Models/ShortLinkLog.dart';
import 'package:link_shortener_mobile/Providers/AuthProvider.dart';
import 'package:link_shortener_mobile/Providers/ShortLinkLogsProvider.dart';
import 'package:link_shortener_mobile/Providers/ShortLinkProvider.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';

const color1 = Color(0xffeabfff);
const color2 = Color(0xff3c005a);
const color3 = Color(0xff800080);
const color4 = Color(0xffd580ff);
const colorBackground = Color(0xfffff3fd);

const colorText1 = Color(0xff2E384D);
const colorText2 = Color(0xff91A1B4);

String formatDate(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  DateFormat formatter = DateFormat('HH:mm dd-MM-yyyy');
  String formattedDateTime = formatter.format(dateTime);
  return formattedDateTime;
}

class DetailView extends StatefulWidget {
  final ShortLink link;

  const DetailView({super.key, required this.link});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  int page = 0;
  bool isDescending = true;
  bool endOfList = false;

  int? totalCount;

  List<ShortLinkLog> shortLinkLogs = [];

  void clearList() {
    page = 0;
    endOfList = false;
    shortLinkLogs.clear();
  }

  void fetchData({bool? refresh}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ShortLinkLogsProvider>(context, listen: false)
          .getShortLinkLogs(
              shortLinkId: widget.link.id!,
              page: page,
              isDescending: isDescending,
              refresh: refresh);
    });
  }

  final ScrollController _scrollController = ScrollController();

  void _onScroll() {
    var pos = _scrollController.position;
    if (pos.pixels == pos.maxScrollExtent && endOfList == false) {
      page += 1; // increment page
      fetchData(refresh: true);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    fetchData(refresh: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text(
          'Kısa Link Raporu',
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 32,
              color: colorText1,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var dialog = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Bu işlem geri alınamaz'),
              content: Text(
                  '${widget.link.name} adlı kısa linki silmek istediğinize emin misiniz?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Hayır'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Evet'),
                ),
              ],
            ),
          );
          if (dialog == true) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Provider.of<ShortLinkProvider>(context, listen: false)
                  .deleteShortLink(context, widget.link.id!);
            });
          }
        },
        shape: const CircleBorder(),
        child: const Icon(
          Icons.delete,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Consumer<ShortLinkProvider>(builder: (context, value, child) {
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
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(fontSize: 24)),
                  ),
                );
              }

              return InfoSectionWidget(
                name: widget.link.name!,
                redirectUrl: widget.link.redirectUrl!,
                uniqueCode: widget.link.uniqueCode!,
                createdDate: widget.link.createDate!,
                updateDate: widget.link.updateDate!,
                clickCount: widget.link.clickCount!,
              );
            }),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 0.7,
                color: colorText1,
              ),
            ),
            Consumer<ShortLinkLogsProvider>(builder: (context, value, child) {
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
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(fontSize: 24)),
                  ),
                );
              }

              final dto = value.response as ShortLinkLogsResponseDTO;
              if ((dto.page! + 1) * dto.take! >= dto.totalCount!)
                endOfList = true;
              shortLinkLogs.addAll(dto.shortLinkLogs!);

              return Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: shortLinkLogs.length,
                    itemBuilder: (context, index) {
                      final log = shortLinkLogs[index];
                      return LogItemWidget(log: log);
                    }),
              );
            })
          ],
        ),
      ),
    );
  }
}

class LogItemWidget extends StatelessWidget {
  const LogItemWidget({
    super.key,
    required this.log,
  });

  final ShortLinkLog log;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Icon(
                    Icons.login,
                    size: 32,
                    color: color3,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Giriş tarihi: ${formatDate(log.redirectTime!)}',
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(fontSize: 18),
                          height: 1.2,
                          color: colorText1),
                    ),
                    Text(
                      ('${log.ipAddress}/${log.userAgent}'.length <= 30)
                          ? '${log.ipAddress}/${log.userAgent}'
                          : '${log.ipAddress}/${log.userAgent}'.substring(30),
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              color: colorText2,
                              fontStyle: FontStyle.italic)),
                    )
                  ],
                )
              ],
            ),
          ]),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            thickness: 0.15,
            color: colorText2,
          ),
        )
      ],
    );
  }
}

class InfoSectionWidget extends StatelessWidget {
  final String name;
  final String redirectUrl;
  final String uniqueCode;
  final String createdDate;
  final String updateDate;
  final int clickCount;

  const InfoSectionWidget(
      {super.key,
      required this.name,
      required this.redirectUrl,
      required this.uniqueCode,
      required this.createdDate,
      required this.updateDate,
      required this.clickCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                    color: colorText1,
                    fontSize: 48,
                    fontWeight: FontWeight.w300,
                    height: 1)),
          ),
          Text(
            redirectUrl,
            style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DetailWidget(countText: '/$uniqueCode', icon: Icons.link),
                    IconButton(
                        onPressed: () {
                          Clipboard.setData(new ClipboardData(
                                  text: '${Httpbase().baseUrl}/$uniqueCode'))
                              .then((_) => ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      content: Text('Panoya kopyalandı.'))));
                        },
                        icon: const Icon(Icons.copy))
                  ],
                ),
                const Divider(
                  thickness: 0.6,
                  color: colorText1,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Oluşturulma Tarihi",
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: colorText1,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300)),
                              ),
                              Text(
                                formatDate(createdDate),
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        color: colorText2,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: DetailWidget(
                            countText: clickCount.numeral(digits: 0),
                            infoText: "Tıklanma Sayısı",
                            icon: Icons.ads_click_outlined),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DetailWidget extends StatelessWidget {
  final String countText;
  final String? infoText;
  final IconData icon;
  final bool iconEnd;

  DetailWidget(
      {super.key,
      required this.countText,
      required this.icon,
      this.infoText,
      this.iconEnd = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!iconEnd)
                  Icon(
                    icon,
                    size: 24,
                    color: color2,
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    countText.length <= 13
                        ? countText
                        : '${countText.substring(0, 13)}...',
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            color: colorText1,
                            fontSize: 36,
                            fontWeight: FontWeight.w300,
                            height: 1)),
                  ),
                ),
                if (iconEnd)
                  Icon(
                    icon,
                    size: 24,
                    color: color2,
                  ),
              ],
            ),
            if (infoText != null)
              Text(
                infoText!,
                style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.w300)),
              ),
          ],
        ),
      ],
    );
  }
}
