import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:link_shortener_mobile/Core/HttpBase.dart';
import 'package:link_shortener_mobile/Core/MainHub.dart';
import 'package:link_shortener_mobile/Models/DTO/ShortLinkLogsDTO.dart';
import 'package:link_shortener_mobile/Models/ShortLink.dart';
import 'package:link_shortener_mobile/Models/ShortLinkLog.dart';
import 'package:link_shortener_mobile/Providers/ShortLinkLogsProvider.dart';
import 'package:link_shortener_mobile/Providers/ShortLinkProvider.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';

String formatDate(String? dateTimeString) {
  if (dateTimeString == null) return "?????";

  DateTime dateTime = DateTime.parse(dateTimeString);
  DateFormat formatter = DateFormat('HH:mm dd/MM/yyyy');
  String formattedDateTime = formatter.format(dateTime);
  return formattedDateTime;
}

class DetailView extends StatefulWidget {
  final ShortLink link;

  const DetailView({super.key, required this.link});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> with TickerProviderStateMixin {
  int page = 0;
  int newCount = 0;
  bool isDescending = true;
  bool endOfList = false;

  List<ShortLinkLog> shortLinkLogs = [];

  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

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

    if (MainHub().hubConnection != null) {
      MainHub().hubConnection!.on("ReceieveLog#${widget.link.id}", (log) {
        setState(() {
          ShortLinkLog shortLinkLog = ShortLinkLog.fromJson(
              json.decode(log.toString())[0] as Map<String, dynamic>);
          newCount += 1;
          shortLinkLog.liveLog = true;
          Future.delayed(const Duration(seconds: 4, milliseconds: 500))
              .then((val) {
            shortLinkLog.liveLog = false;
          });
          shortLinkLogs.insert(0, shortLinkLog);
        });
      });
    }

    // animasyonla alakalı
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1, milliseconds: 500),
    )..repeat(reverse: true);

    _animationController.addListener(() {
      setState(() {});
    });

    _scrollController.addListener(_onScroll);
    clearList();
    fetchData(refresh: false);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    if (MainHub().hubConnection != null) {
      MainHub().hubConnection!.off("ReceieveLog#${widget.link.id}");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _colorAnimation = ColorTween(
      begin: Colors.green[100],
      end: Theme.of(context).colorScheme.surface,
    ).animate(_animationController);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kısa Link Raporu',
          style: TextStyle(
            fontSize: 28,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                var dialog = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text(
                      'Bu işlem geri alınamaz',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    content: Text(
                        '${widget.link.name} adlı kısa linki silmek istediğinize emin misiniz?'),
                    actions: <Widget>[
                      FilledButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Hayır'),
                      ),
                      FilledButton(
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
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.primary,
              )),
          if (MainHub().hubConnection != null)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Icon(
                Icons.live_tv_rounded,
                color: Colors.redAccent,
              ),
            )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Consumer<ShortLinkProvider>(builder: (context, value, child) {
              if (value.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
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
                    style: const TextStyle(fontSize: 24),
                  ),
                );
              }

              return InfoSectionWidget(
                name: widget.link.name!,
                redirectUrl: widget.link.redirectUrl!,
                uniqueCode: widget.link.uniqueCode!,
                createdDate: widget.link.createDate!,
                updateDate: widget.link.updateDate!,
                clickCount: widget.link.clickCount! + newCount,
              );
            }),
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Kayıtlar',
                  style: TextStyle(
                    fontSize: 32,
                    color: Theme.of(context).colorScheme.secondaryFixed,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 0.7,
              ),
            ),
            Consumer<ShortLinkLogsProvider>(builder: (context, value, child) {
              if (value.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
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

              if (value.response != null) {
                final dto = value.response as ShortLinkLogsResponseDTO;
                if ((dto.page! + 1) * dto.take! >= dto.totalCount!)
                  endOfList = true;
                shortLinkLogs.addAll(dto.shortLinkLogs!);

                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  Provider.of<ShortLinkLogsProvider>(context, listen: false)
                      .resetState(context);
                });
              }

              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: shortLinkLogs.length,
                  itemBuilder: (context, index) {
                    final log = shortLinkLogs[index];
                    return AnimatedBuilder(
                      animation: _colorAnimation,
                      builder: (context, child) {
                        return Container(
                          color: (log.liveLog)
                              ? _colorAnimation.value
                              : Theme.of(context).colorScheme.surface,
                          // child: LogItemWidget(log: log),
                          child: ListTile(
                            title: Text(
                              'Giriş tarihi: ${formatDate(log.redirectTime)}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              ('${log.ipAddress}/${log.userAgent}'.length <= 30)
                                  ? '${log.ipAddress}/${log.userAgent}'
                                  : '${log.ipAddress}/${log.userAgent}'
                                      .substring(0, 30),
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            leading: const Icon(
                              Icons.login,
                              size: 28,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
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
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Giriş tarihi: ${formatDate(log.redirectTime)}',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(fontSize: 18),
                        height: 1.2,
                      ),
                    ),
                    Text(
                      ('${log.ipAddress}/${log.userAgent}'.length <= 30)
                          ? '${log.ipAddress}/${log.userAgent}'
                          : '${log.ipAddress}/${log.userAgent}'
                              .substring(0, 30),
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontSize: 14, fontStyle: FontStyle.italic)),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 36,
                        color: Theme.of(context).colorScheme.primary,
                        height: 1,
                      ),
                    ),
                    Text(
                      (redirectUrl.length < 25)
                          ? redirectUrl
                          : "${redirectUrl.substring(0, 25)}...",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondaryFixed,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: DetailWidget(
                      countText: clickCount.numeral(digits: 0),
                      infoText: "Tıklanma Sayısı",
                      icon: Icons.ads_click_outlined),
                ),
              )
            ],
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
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    countText.length <= 13
                        ? countText
                        : '${countText.substring(0, 13)}...',
                    style: TextStyle(
                        fontSize: 36,
                        height: 1,
                        color: Theme.of(context).colorScheme.primaryContainer),
                  ),
                ),
                if (iconEnd)
                  Icon(
                    icon,
                    size: 24,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
              ],
            ),
            if (infoText != null)
              Text(
                infoText!,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.secondaryFixed,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
