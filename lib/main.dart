import 'package:flutter/material.dart';
import 'package:sms/sms.dart';
import 'dart:async';

void main() => runApp(MyApp());

List<SmsThread> messagesSMS;

Future<void> fetchSms() async {
    SmsQuery query = SmsQuery();
    messagesSMS = await query.getAllThreads;
  }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatPage(),
    );
  }
}


class personMessage {
  String name;
  List<String> messages;

}

class ContactThread extends StatefulWidget{
  
  SmsThread _thread;

  ContactThread(SmsThread _thread){
    this._thread = _thread;
  }
  @override
  createState() => ContactThreadState(_thread);
}

class ContactThreadState extends State<ContactThread>{

  SmsThread _thread;

  ContactThreadState(SmsThread _thread){
    this._thread = _thread;
  }

   Widget messageComposer(){
    return Row( 
      children: [
        IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: ()=>print("pressed"),  
        ),
        Flexible(
          child: TextField(
            decoration: InputDecoration(
                hintText: "Compose a message..."
            ),
            onSubmitted: (value){
              print("printing");
            },
          )
        
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: (){}
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }

  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(title: Center(child:Text("${_thread.contact.address}")),
      ),
      body: Container(
        child: ListView.builder(
          reverse: true,
          itemBuilder: (context, index){
            if(index==0){
            print(_thread.messages[index].id);
            print(_thread.messages[index].address);
            print(_thread.messages[index].isRead);
            print(_thread.messages[index].state);
            print(_thread.messages[index].sender);
            }           
            if(_thread.messages[index].sender == _thread.contact.address){
              return Card(
              child: Container(child: Column(children:[Text("${_thread.messages[index].sender}",style: TextStyle(fontSize: 10.0),textAlign: TextAlign.left,),
                Text("${_thread.messages[index].body}",style: TextStyle(fontSize: 20.0),
              softWrap: true, textAlign: TextAlign.right,
                )],
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
              margin: EdgeInsets.all(5.0),
              )
            );
            } else {
            return Card(
              child: Container(child: Column(children:[Text("Me",style: TextStyle(fontSize: 10.0),textAlign: TextAlign.right,),
                Text("${_thread.messages[index].body}",style: TextStyle(fontSize: 20.0),
              softWrap: true, textAlign: TextAlign.right,
                )],
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
              margin: EdgeInsets.all(5.0),
              )
            );
            }
          },
        ),
      ),
      bottomSheet: messageComposer(),
    ); 
  }
}

class HomePage extends StatefulWidget{
  @override
  createState() => new HomePageState();
}

class HomePageState extends State<HomePage>{

  List<String> chatters = ["Example Chat"];

  Widget listChats(BuildContext context){
    fetchSms();
    return Container(child: ListView.builder(
        itemCount: messagesSMS.length,
        itemBuilder: (context, index){
          return Container(
            child: ListTile(title: Text("${messagesSMS[index].contact.address}"),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ContactThread(messagesSMS[index])
              ));
            },
            leading: IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: (){},
            ),
            )
          );
        },

    ));
  }

  Widget build(BuildContext context){
      fetchSms();
      return Scaffold(
        appBar: AppBar(title: Text("Chat App Prototype"),),
        body: listChats(context),
      );
  }
}

class ChatPage extends StatefulWidget{
  @override
  createState() => new ChatPageState();
}

class ChatPageState extends State<ChatPage>{

  final formKey = GlobalKey<FormState>();
  final textKey = GlobalKey<FormState>();

  TextEditingController textCont = TextEditingController();

  List<String> messages = [];
  
  //messages.add(okay);

  Widget listMessages(BuildContext context){

      return Container(child:ListView.builder(
        itemBuilder: (context, index){
          return Card(
              child: Container(child: Column(children:[Text("Me",style: TextStyle(fontSize: 10.0),textAlign: TextAlign.right,),
                Text("${messages[index]}",style: TextStyle(fontSize: 20.0),
              softWrap: true, textAlign: TextAlign.right,
                )],
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
              margin: EdgeInsets.all(5.0),
              )
            );
        },
        itemCount: messages.length,
        reverse: true,
      ),
      margin: EdgeInsets.fromLTRB(0,0,0,100),

      );

  }

  void onSubmitted(BuildContext context){
    formKey.currentState.save();
    print(messages[0]);
  }

  void _handleSubmitted(String message){
    textCont.clear();
    setState(() {
          messages.insert(0, message);
        });
  }
  

  Widget messageComposer(){
    return Row( 
      children: [
        IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: ()=>print("pressed"),  
        ),
        Flexible(
          child: TextField(
            decoration: InputDecoration(
                hintText: "Compose a message..."
            ),
            onSubmitted: _handleSubmitted,
            controller: textCont,
            key: textKey,
          )
        
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: (){
            setState(() {
              messages.insert(0, textCont.text);              
                        });
            textCont.clear();
          }
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }

  Widget build(BuildContext context){
    fetchSms();
    return Scaffold(
      key: formKey,
      appBar: AppBar(
        title: Center(child:Text("Example Chat")),
        leading: 
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => HomePage()
              ));
            },
          )),
      body: listMessages(context),
      bottomSheet: messageComposer()
    );
  }
}