import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/core/constants/value.dart';
import 'package:todo_app/app/routes/paths.dart';

class ManagementTataKelola extends ConsumerWidget {
  const ManagementTataKelola({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: List.generate(
              6,
              (index) => BoxStaff(
                name: 'Ks. Pem',
                image: 'assets/images/kasi_pemerintah.jpg',
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      itemCount: 20,
                      itemBuilder: (BuildContext context, int index) {
                        return KegiatanProgress(
                          name: "Kegiatan $index",
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KegiatanProgress extends StatelessWidget {
  final String name;
  const KegiatanProgress({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name),
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
              Container(
                width: MediaQuery.of(context).size.width * (70 / 100),
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

class BoxStaff extends StatelessWidget {
  final String name;
  final String image;
  const BoxStaff({
    Key? key,
    required this.name,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Paths.managementTataKelolaDetail('1'),
          extra: {'id': 1, 'name': name}),
      child: Container(
        height: 68,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.purple[100]),
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
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  )),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
