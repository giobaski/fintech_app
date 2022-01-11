import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:skany/controllers/auth_controller.dart';
import 'package:skany/controllers/bank_controller.dart';
import 'package:skany/controllers/installment_controller.dart';
import 'package:skany/views/widgets/botom_navigation_bar.dart';
import 'package:skany/views/widgets/custom_drawer.dart';

import 'installment_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final installmentController = Get.put(InstallmentController());
  final bankController = Get.put(BankController());
  final AuthController authController = Get.find(); //Todo:delete

  final TextEditingController _storeCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("#### Home, appUser: ${authController.appUser.value}") ;//Todo:delete
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("მთავარი გვერდი"),
          centerTitle: true,
          // backgroundColor: Colors.transparent,
          elevation: 0,
          backgroundColor: Colors.indigo,
          actions: [
            Icon(Icons.notifications)
            // CircleAvatar(
            //   radius: 20.0,
            //   backgroundColor: Colors.amber,
            //   child: Text("GT"),
            // )
          ]),

      drawer: CustomDrawer(),
      bottomNavigationBar: MyBottomnavigationBar(),

      body: SingleChildScrollView(
        child: Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            //Header
            Container(
              margin: EdgeInsets.only(bottom: 30.0),
              alignment: Alignment.topCenter,
              height: 105.0,
              decoration: BoxDecoration(
                  gradient: _buildHomeHeaderGradient(),
                  // color: Colors.teal,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(60),
                  )),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("ვერიფიცირებული მომხმარებელი", style: TextStyle(color:Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  Text("19001065613", style: TextStyle(color:Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  (authController.appUser.value.isVerified == 1) ? Icon(Icons.verified, color: Colors.green) : Icon(Icons.not_interested_rounded, color: Colors.red)
                ],
              ),
            ),

            // მაღაზიის კოდის გაგზავნის სექცია
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("ახალი განვადების დაწყება",
                  style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            Card(
              elevation: 10.0,
              child: Container(
                //Todo: remove this container
                // height: 100,
                // width: MediaQuery.of(context).size.width*0.8,
                color: Colors.white60,
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("პარტნიორი ორგანიზაცია",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Container(
                              height: 40,
                              child: TextField(
                                controller: _storeCodeController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  labelText: "შეიყვანეთ კოდი",
                                  hintText: "9-11 ციფრი",
                                  hintStyle: TextStyle(fontSize: 12.0),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            )),
                        SizedBox(width: 5),
                        Expanded(
                            child: Container(
                                height: 40,
                                child:
                                // Obx(() =>
                                    ElevatedButton(
                                        child: Text("შემოწმება"),
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
                                        onPressed: () async {
                                              if(await installmentController.checkStore(_storeCodeController.text.trim())){
                                                Get.defaultDialog(
                                                  title: "ახალი განვადება!",
                                                  content: Obx(()=>
                                                      Column(
                                                        children: [
                                                          Text(installmentController.storeTitle.value, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                                                          SizedBox(height: 5),
                                                          Text("ნამდვილად გსურთ განვადების დაწყება აღნიშულ ორგანიზაციაში?", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                                        ],
                                                      )
                                                  ),
                                                  cancel: TextButton(onPressed: (){Get.back();}, child: Text("გაუქმება", style: TextStyle(color: Colors.redAccent),),),
                                                  confirm: ElevatedButton(onPressed: (){
                                                    installmentController.storeNewInstallment();
                                                  }, child: Text("დიახ")),
                                                );
                                              }
                                              _storeCodeController.clear();
                                            },

                                    )
                                // )
                            )
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // განვადებების სიის სექცია
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("ჩემი განვადებები",style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width: 5),
                  Icon(Icons.assignment_outlined, size: 20, color: Colors.indigo),
                ],
              ),
            ),

            Divider(),
            Container(
              height: 300,
              padding: EdgeInsets.symmetric(horizontal: 14),
              // elevation: 10.0,
              child:
              Obx(() {
                if (installmentController.isLoading.value){
                  return Center(child: CircularProgressIndicator());
                } else if (installmentController.myInstallments.length == 0){
                  return Padding(padding: EdgeInsets.all(45),
                      child: Text("თქვენ არ გაქვთ განვადებები!",
                        style: TextStyle(color: Colors.white, backgroundColor:Colors.redAccent, fontWeight: FontWeight.bold),));
                 } else {
                  return ListView.builder(
                      scrollDirection: Axis.vertical, // Todo: change this
                      shrinkWrap: true,
                      // physics: const AlwaysScrollableScrollPhysics(),
                      // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      itemCount: installmentController.myInstallments.length,
                      itemBuilder: (context, index){
                      return Column(
                        children: [
                          Card(
                            child: ListTile(
                              leading:
                              // Text("#"+installmentController.myInstallments[index].id.toString(), style:TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              CircleAvatar(
                                child: Text("#" + installmentController.myInstallments[index].id.toString(), style:TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                                backgroundColor: Colors.grey,
                              ),
                              title: Text(installmentController.myInstallments[index].storeTitle!),
                              subtitle: Text(installmentController.myInstallments[index].date.toString()),
                              trailing: Text(installmentController.myInstallments[index].installmentStatus!,
                                    style: (installmentController.myInstallments[index].installmentStatus == "შევსებული")
                                        ? TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)
                                        : TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.redAccent),
                                ),

                              onTap: () async { //Todo: remove Future<void>
                                print("####ID: "+ installmentController.myInstallments[index].id.toString());

                                await installmentController.getInstallmentById(installmentController.myInstallments[index].id.toString());

                                Get.to(InstallmentDetailsPage(),
                                  arguments: installmentController.myInstallments[index],
                                );
                              },
                              onLongPress: (){
                                Get.defaultDialog(
                                  title: "დეტალები: ${installmentController.myInstallments[index].storeTitle}"
                                );
                                    },
                            ),
                          )
                        ],
                      );
                      }
                  );
                }
              }),
            ),

                // Placeholder(
                //     color: Colors.grey,
                //   fallbackHeight: 100,
                // ),

                InkWell(
                  onTap: () {
                    //open new screen where you explain how trading works
                  },
                  child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(50)),
                        // color: Colors.teal,
                      ),
                      child: Center(
                        child: Image.asset('assets/images/work.png',
                            fit: BoxFit.cover),
                      )),
                ),



          ]),
        ),
      ),
    );
  }




  LinearGradient _buildHomeHeaderGradient () {
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [
        0.4,
        // 0.4,
        // 0.6,
        0.9,
      ],
      colors: [
        // Colors.deepPurple,
        // Colors.white,
        Colors.indigo,
        Colors.indigoAccent,
      ],
    );
  }



}
