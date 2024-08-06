import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:link_shortener_mobile/Core/Debouncer.dart';
import 'package:link_shortener_mobile/Models/DTO/ShortLinksResponseDTO.dart';
import 'package:link_shortener_mobile/Models/ShortLink.dart';
import 'package:link_shortener_mobile/Providers/AuthProvider.dart';
import 'package:link_shortener_mobile/Providers/ShortLinkProvider.dart';
import 'package:link_shortener_mobile/Views/DetailView.dart';
import 'package:link_shortener_mobile/Views/LoginView.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int page = 0;
  bool isDescending = true;
  String sortBy = "id";
  bool endOfList = false;
  String nameSearch = "";
  String currentOrderState = "id-desc";

  int? totalCount;

  List<ShortLink> shortLinks = [];
  Debouncer searchDebouncer = Debouncer();

  void clearList() {
    page = 0;
    endOfList = false;
    shortLinks.clear();
  }

  void fetchData({bool? refresh}) {
    if (nameSearch == "") totalCount = null;

    var splited = currentOrderState.split("-");
    sortBy = splited[0];
    if (splited[1] == 'inc') {
      isDescending = false;
    } else {
      isDescending = true;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ShortLinkProvider>(context, listen: false).getUserShortLinks(
          page: page,
          isDescending: isDescending,
          sortBy: sortBy,
          nameSearch: nameSearch,
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Link Shortener',
            style: TextStyle(
              fontSize: 32,
              color: Theme.of(context).colorScheme.primary,
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
                ))
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              final nameController = TextEditingController();
              final redirectLinkController = TextEditingController();
              final uniqueCodeController = TextEditingController();
              final formKey = GlobalKey<FormState>();

              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Consumer<ShortLinkCreateProvider>(
                      builder: (context, value, child) {
                        return CreateFormWidget(
                            formKey: formKey,
                            nameController: nameController,
                            redirectLinkController: redirectLinkController,
                            uniqueCodeController: uniqueCodeController,
                            modelContext: context,
                            shortLinkCreateProvider: value);
                      },
                    ),
                  ),
                ),
              );
            },
          ).whenComplete(() {
            clearList();
            fetchData(refresh: false);
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Provider.of<ShortLinkCreateProvider>(context, listen: false)
                  .resetState(context);
            });
          }),
          label: const Row(
            children: [
              Icon(
                Icons.add_outlined,
              ),
              Text('Oluştur')
            ],
          ),
        ),
        body: Consumer<ShortLinkProvider>(builder: (context, value, child) {
          // eğer refresh olduysa önceki response duruyordur gerek yok loadinge
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

          final dto = value.response as ShortLinksResponseDTO;

          totalCount ??= dto.totalCount;
          if ((dto.page! + 1) * dto.take! >= dto.totalCount!) endOfList = true;
          shortLinks.addAll(dto.shortLinks!); // listeye ekleme işlemi

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InfoWidget(
                      icon: Icons.link,
                      countText: '$totalCount',
                      infoText: 'Oluşturulan Link Sayısı',
                      iconEnd: true,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kısa Linkler',
                          style: TextStyle(
                            fontSize: 32,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            autofocus: false,
                            decoration: const InputDecoration(
                              border: const UnderlineInputBorder(),
                              hintText: 'İsim ile ara',
                            ),
                            onChanged: (v) {
                              nameSearch = v;
                              clearList();
                              searchDebouncer
                                  .debounce(() => fetchData(refresh: true));
                            },
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SortDropdownIconButton(
                      onSelect: (value) {
                        currentOrderState = value;
                        clearList();
                        fetchData(refresh: true);
                      },
                      items: const {
                        'click-desc': ('En fazla tıklanan', null),
                        'click-inc': ('En az tıklanan', null),
                        'id-desc': ('En Yeni', null),
                        'id-inc': ('En Eski', null),
                        'name-inc': ('Alfabeye göre [A-Z]', null),
                        'name-desc': ('Alfabeye göre [Z-A]', null)
                      },
                      iconData: Icons.format_line_spacing,
                      currentOrderState: currentOrderState,
                    )
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 75),
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemCount: shortLinks.length,
                      itemBuilder: (BuildContext context, int index) {
                        ShortLink link = shortLinks[index];
                        return TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    DetailView(link: link),
                              ),
                            ).whenComplete(() {
                              clearList();
                              fetchData(refresh: false);
                            });
                          },
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder()),
                          child: ListTile(
                            title: Text(
                              link.name!,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(
                              link.redirectUrl!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            leading: const Icon(
                              Icons.link,
                              size: 28,
                            ),
                            trailing: Text(
                              link.clickCount.toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryFixed),
                            ),
                          ),
                        );
                      }),
                  onRefresh: () async {
                    clearList();
                    fetchData(refresh: true);
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class CreateFormWidget extends StatelessWidget {
  const CreateFormWidget(
      {super.key,
      required this.formKey,
      required this.nameController,
      required this.redirectLinkController,
      required this.uniqueCodeController,
      required this.modelContext,
      required this.shortLinkCreateProvider});

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController redirectLinkController;
  final TextEditingController uniqueCodeController;
  final BuildContext modelContext;
  final ShortLinkCreateProvider shortLinkCreateProvider;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            const CircleAvatar(
              radius: 32,
              backgroundImage: AssetImage('assets/icon.png'),
            ),
            const SizedBox(height: 10),
            // Title
            const Text(
              'Kısa Linkinizi oluşturun',
              style: TextStyle(
                fontSize: 32,
              ),
            ),

            if (shortLinkCreateProvider.isLoading)
              const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 8,
                ),
              ),

            if (shortLinkCreateProvider.errorDto != null)
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  '${shortLinkCreateProvider.errorDto!.error_message}',
                ),
              ),

            const SizedBox(height: 20),
            // Username field
            InputField(
              controller: nameController,
              hintText: 'Takma Ad',
              autoFocus: true,
            ),
            const SizedBox(
              height: 5,
            ),
            InputField(
              controller: redirectLinkController,
              hintText: 'Kısaltmak istediğiniz link',
              autoFocus: true,
            ),
            const SizedBox(
              height: 5,
            ),
            InputField(
              controller: uniqueCodeController,
              required: false,
              hintText: 'Özel kısa linkiniz (opsiyonel)',
              autoFocus: true,
            ),
            const SizedBox(height: 15),
            SubmitButton(
              text: 'Oluştur',
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final name = nameController.text;
                  final redirectLink = redirectLinkController.text;
                  final uniqueCode = uniqueCodeController.text.length >= 1
                      ? uniqueCodeController.text
                      : null;
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    Provider.of<ShortLinkCreateProvider>(context, listen: false)
                        .createShortLink(
                            modelContext, name, redirectLink, uniqueCode);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LinkItem extends StatelessWidget {
  final String name;
  final String url;
  final int count;

  const LinkItem(
      {super.key, required this.name, required this.url, required this.count});

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
                    Icons.link,
                    size: 32,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.length <= 30 ? name : '${name.substring(0, 30)}...',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(fontSize: 26),
                        height: 1.2,
                      ),
                    ),
                    Text(
                      url.length <= 30 ? url : '${url.substring(0, 30)}...',
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontSize: 16, fontStyle: FontStyle.italic)),
                    )
                  ],
                )
              ],
            ),
            CircleAvatar(
                radius: 24,
                child: Center(
                  child: Text(
                    count.numeral(digits: 0),
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300)),
                  ),
                ))
          ]),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            thickness: 0.5,
          ),
        )
      ],
    );
  }
}

class SortDropdownIconButton extends StatelessWidget {
  final Map<String, (String, IconData?)> items;
  final IconData iconData;
  final Function(dynamic)? onSelect;
  final String currentOrderState;

  SortDropdownIconButton(
      {super.key,
      required this.items,
      required this.iconData,
      required this.currentOrderState,
      this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: PopupMenuButton(
        onSelected: (v) {
          if (onSelect != null) onSelect!(v);
        },
        itemBuilder: (BuildContext context) {
          List<PopupMenuEntry> list = [];
          items.forEach((k, v) {
            list.add(PopupMenuItem(
              value: k,
              child: Row(
                children: [
                  if (k == currentOrderState)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(
                        Icons.circle,
                        size: 8,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                  Text(
                    v.$1,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ],
              ),
            ));
          });
          return list;
        },
        child: CircleAvatar(
          child: Icon(
            iconData,
          ),
        ),
      ),
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
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    countText,
                    style: TextStyle(
                        fontSize: 56,
                        height: 1.2,
                        color: Theme.of(context).colorScheme.primaryContainer),
                  ),
                ),
                if (iconEnd)
                  Icon(
                    icon,
                    size: 48,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
              ],
            ),
            Text(
              infoText,
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
