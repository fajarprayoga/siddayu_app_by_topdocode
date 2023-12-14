import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletons/skeletons.dart';
import 'package:todo_app/app/core/constants/value.dart';
import 'package:todo_app/app/providers/kegiatan/kegiatan_detail_provider.dart';
import 'package:todo_app/app/providers/user/user_provider.dart';
import 'package:todo_app/app/routes/paths.dart';
import 'package:todo_app/app/widgets/widget.dart';

class ManagementTataKelola extends ConsumerWidget {
  const ManagementTataKelola({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProviderData = ref.watch(userProvider);
    final kegiatanProviderData = ref.watch(kegiatanDetailProvider);

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            userProviderData.when(
                data: (userData) {
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: List.generate(
                      userData.length,
                      (index) => BoxStaff(
                        name: userData[index].username,
                        image: userData[index].image,
                      ),
                    ),
                  );
                },
                error: (error, stackTrace) => Text('Error: $error'),
                loading: () => BoxStaffPlaceholder()),
            SizedBox(height: 20),
            kegiatanProviderData.when(
                data: (kegiatanData) {
                  return Expanded(
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey,
                            blurRadius: 4,
                            offset: Offset(0, 1), // Posisi bayangan
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Progress Kegiatan',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("All"),
                                    Icon(
                                      Icons.arrow_right,
                                      size: 36,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: gap),
                          Expanded(
                            child: ListView.builder(
                              itemCount: kegiatanData.length,
                              itemBuilder: (BuildContext context, int index) {
                                return KegiatanProgress(
                                  name: kegiatanData[index].todo,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                error: (error, stackTrace) => Text('Error: $error'),
                loading: () => CircularProgressIndicator())
          ],
        ));
  }
}

class KegiatanProgress extends StatefulWidget {
  final String name;
  const KegiatanProgress({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  State<KegiatanProgress> createState() => _KegiatanProgressState();
}

class _KegiatanProgressState extends State<KegiatanProgress> {
  double _width = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Memanggil setState setelah frame saat ini selesai diproses
      setState(() {
        _width = MediaQuery.of(context).size.width * (70 / 100);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.name),
          SizedBox(
            height: gap,
          ),
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(10)),
                height: 21,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                width: _width,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(10)),
                height: 21,
              )
            ],
          )
        ],
      ),
    );
  }
}

class BoxStaff extends StatefulWidget {
  final String name;
  final String image;
  const BoxStaff({
    Key? key,
    required this.name,
    required this.image,
  }) : super(key: key);

  @override
  State<BoxStaff> createState() => _BoxStaffState();
}

class _BoxStaffState extends State<BoxStaff> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Paths.managementTataKelolaDetail('1'),
          extra: {'id': 1, 'name': widget.name}),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 800),
        opacity: 1,
        child: Container(
          height: 68,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.purple[100]),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          width: (MediaQuery.of(context).size.width / 2) - 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(widget.image),
                      fit: BoxFit.cover,
                    )),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                widget.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
