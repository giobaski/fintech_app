import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skany/controllers/bank_controller.dart';
import 'package:skany/controllers/installment_controller.dart';
import 'package:skany/models/installment.dart';


class InstallmentDetailsPage extends StatefulWidget {
  InstallmentDetailsPage({Key? key}) : super(key: key);

  @override
  State<InstallmentDetailsPage> createState() => _InstallmentDetailsPageState();
}

class _InstallmentDetailsPageState extends State<InstallmentDetailsPage> {
  final InstallmentController installmentController = Get.find();
  final BankController bankController = Get.find();

  // final Installment installment = Get.arguments;  //single installment, getting from homePage->onTap()
  // var installmentId = Get.arguments;
  // late final installment;
  late final Installment installment;

  @override
  void initState() {
    installment = installmentController.installment.value;

    // installmentController.getInstallmentById(installment.id.toString());

    // installment = installmentController.getInstallmentById(installmentId);
    // installment = installmentController.installment.value;
  }


  @override
  Widget build(BuildContext context) {
    
    print("##### installment detail: " + installment.toString());
    print("###DetPage...after get_installmentById: " + installmentController.installment.value.toString());

    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");

    return Scaffold(
      appBar: AppBar(title: Text("ინვოისი #" + installment.id.toString()),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.indigo,
      ),

      body: SingleChildScrollView(
        child:
    // Obx(()=>
        Column(
          children: [
            //Todo: create _builderInviceGeneralHeader()
            Container(
              // height: 200,
              color: Colors.indigo,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Todo: delete
                  // Text("### DEBUG:" + installmentController.installment.value.toString()),
                  // Text("test delete" + installmentController.installment),

                  SizedBox(height: 20),
                    ListTile(
                      title: Text("პარტნიორი:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(installment.storeTitle!, style: TextStyle(color: Colors.white)),
                      trailing: Container(
                        color: Colors.indigo,
                          padding: EdgeInsets.all(5),
                          child: Text(installment.installmentStatus!, style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold))),
                      dense: true,
                      contentPadding: EdgeInsets.all(0),

                    ),
                    ListTile(
                      title: Text("კლიენტი:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(installment.userName!, style: TextStyle(color: Colors.white)),
                          Text("პ/ნ: " + installment.userPn!, style: TextStyle(color: Colors.white)),
                          Text("ტელ: " + installment.userPhone!, style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      dense: true,
                      contentPadding: EdgeInsets.all(0),

                    ),
                    ListTile(
                      title: Text("თარიღი:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(dateFormat.parse(installment.date.toString()).toString(), style: TextStyle(color: Colors.white)),
                      dense: true,
                      contentPadding: EdgeInsets.all(0),
                    ),

                  SizedBox(height: 15)
                ],
              ),
            ),

          //პროდუქტების ცხრილი DataTable()
          displayWidgetsBasedOnInstallmenStatus(installment.installmentStatus!),

          //Todo: დაამატე Tab სადაც მეორე ტაბში პროდუქტები გამოჩნდება?
          ],
        ),
      // ),
      ),
    );
  }


  //My Widgets
  //use switch case here?
  Widget displayWidgetsBasedOnInstallmenStatus(String status) {
    if (status == "ახალი") {
      return _displayTextAboutEmptyProducts();
    } else if (status == "შევსებული") {
      return _buildProductsTableAndAcceptBtn();
    } else {
      return Text(
          "დამტკიცებული, გაეცანი პირობებს და მოაწერე ხელი ხელშეკრულებას!"); //or any other widget but not null
    }
  }

  Widget _buildProductsTableAndAcceptBtn () {
    return  Column(
      children: [
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20,
            // headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
            columns: [
              DataColumn(label: Text("დასახელება", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
              DataColumn(label: Text("რაოდენობა", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),)),
              DataColumn(label: Text("ერთ_ფასი", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),)),
              DataColumn(label: Text("ჯამი", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),)),
            ],
            rows: installment.products!
                .map(
                  (product) => DataRow(cells: [
                DataCell(Text(product.name.toString())),
                DataCell(Text(product.amount.toString())),
                DataCell(Text(product.price.toString())),
                DataCell(Text(product.total.toString()))
                  ]),
            ).toList(),
          ),
        ),

        //Products footer
        Divider(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("საერთო ღირებულება: ${installment.productsTotalPrice} ",
                style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold)),
            Divider(),
          ],
        ),

        //Todo: თანხმობის ღილაკები გამოჩენა გადაიტანე პროდუქტების ვიჯეტებთან, შევსებული სტატუსის შემთხვევაში უნდ აგამოჩნდეს
        //თანხმობის და ბანკში გადაგზავნის ღილაკები (გამოაჩინე მხოლოდ მაშინ თუ სტატუსი არის "შევსებული",
        // სხვა სტატუსებზე ("განსახილველი, დამტკიცებული, უარყოფილი" -  ბანკის დეტალების გვერდზე)
        SizedBox(height: 40),
        Divider(color: Colors.indigo, indent: 10, endIndent: 10, thickness: 1),
        //Todo:ეს კითხვა ხო არ ჯობია? "ადასტურებთ თუ არა შევსებულ ინფორმაციას?"
        // Text("თანახმა ხართ თუ არა გადაიგზავნოს ბანკში?", style: TextStyle(color: Colors.indigo, fontSize: 12, fontWeight: FontWeight.bold)),
        Text("ეთანხმებით თუ არა აღნიშნულ ინვოისს?", style: TextStyle(color: Colors.indigo, fontSize: 12, fontWeight: FontWeight.bold)),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.check, size: 18),
              label: Text("დიახ!"),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.teal)),
              onPressed: () {
                // თანხმობაზე დაჭერის შემთხვევაში ამოდის დიალოგი,
                // სადაც ხდება ბანკის არჩევა და განაცხადის გადაგზავნა
                _bankSelectionDialog();
              },
            ),

            ElevatedButton.icon(
              onPressed: () {
                // Respond to button press
              },
              icon: Icon(Icons.delete, size: 18),
              label: Text("უარყოფა"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)
              ),
            )
          ],
        ),


      ],
    );
  }


  Future _bankSelectionDialog () => Get.defaultDialog(
      title: "აირჩიეთ სასურველი საფინანსო დაწესებულება, სადაც გსურთ განაცხადის გაგზავნა",
      titleStyle: TextStyle(fontSize: 12, color: Colors.grey),
      middleText: "text",
      // backgroundColor: Colors.indigo,
      // radius: 10,
      // textConfirm: "გაგზავნა",
      // confirmTextColor: Colors.white,
      // buttonColor: Colors.indigo,
      // onConfirm: (){},
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
          //Todo: update current installment to see new status

          Get.snackbar("განაცხადი წარმატებით გაიგზავნა!", "",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: Duration(seconds: 3));
        },
        child: Text("გაგზავნა"),
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.indigo)),
      ),

      cancel: TextButton(onPressed: (){Get.back();}, child: Text("უკან", style: TextStyle(color: Colors.redAccent),),),

      //სასურველი ბანკის არჩევა
      content: Column(
        children: [
          // Text("აირჩიეთ სასურველი ბანკი"),
          Obx(
            () => DropdownButton<String>(
              value: bankController.selectedBank.value,
              onChanged: (selectedBank) {
                bankController.selectedBank.value = selectedBank!;
              },
              isExpanded: true,
              iconSize: 32,
              icon: Icon(Icons.arrow_drop_down, color: Colors.black),
              items: bankController.availableBanks
                  .map((bank) => DropdownMenuItem<String>(
                        value: bank.title,
                        child: Text(bank.title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ))
                  .toList(),
            ),
          ),

          SizedBox(height: 10),
          Container(
            height: 40,
            child: TextField(
              // controller: _storeCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: "მოთხოვნილი ვადა(თვე)",
                hintText: "0-36",
                hintStyle: TextStyle(fontSize: 12.0),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 40,
            child: TextField(
              // controller: _storeCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                fillColor: Colors.white,
                labelText: "სასურველი გადახდის რიცხვი",
                hintText: "1-31",
                hintStyle: TextStyle(fontSize: 12.0),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ));


  Widget _displayTextAboutEmptyProducts() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text("დაელოდეთ ინვოისის შევსებას!",
                style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)
            ),
          ),
          Text("პროდუქტი/სერვისი არაა დამატებული "
              "ინვოისში პარტნიორი ორგანიზაციის მიერ (Debug: use StreamBuilder)",
            style: TextStyle(color: Colors.grey),
          ),
          ElevatedButton(
              onPressed: (){
                installmentController.getInstallmentById(installment.id.toString());
              },
              child: Text("განახლება"),
              style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
          ),
          //Todo: დაამატე ტაიმერი, ინვოისის შექმნიდან პროდუქტების დამატებამდე წუთების ასათვლელად
          Card(
            child: Text("Text Placeholder"),
          )
        ],
      ),
    );
  }

}//End

