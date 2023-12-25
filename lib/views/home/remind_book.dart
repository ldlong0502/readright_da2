

import 'package:ebook/view_models/remind_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class RemindBookDialog extends StatelessWidget {
  const RemindBookDialog({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Consumer<RemindProvider>(
      builder: (context , event, _) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20)
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                  child: Text(
                    'Nhắc nhở đọc sách',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
               Icon(
                event.isRemind ? Icons.alarm : Icons.alarm_off,
                size: 60,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Cho phép ứng dụng gửi Notification nhắc nhở bạn đọc sách hằng ngày với những câu nói hay và đầy ý nghĩa về sách',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30.0),
              TimePickerSpinnerPopUp(
              mode: CupertinoDatePickerMode.time,
              initTime: event.timeAlarm,
              onChange: (dateTime) {
                event.setTimeAlarm(dateTime);
              },
              cancelText: 'Hủy',
              padding: const EdgeInsets.all(20),

            ),
             const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              
              InkWell(
                onTap: () async {
                  Navigator.pop(context);
                  event.setRemind(true);
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(child: Text('Lưu nhắc nhở', style: TextStyle(
                    color: Colors.white
                  ),) ),),
              ),
              InkWell(
                onTap: (){
                   Navigator.pop(context);
                  event.setRemind(false);
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black)),
                  child: const Center(child: Text('Hủy nhắc nhở')),
                ),
              ),
            ],)
            ],
          ),
        );
      }
    );
  }
}
