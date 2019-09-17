import 'package:rxdart/rxdart.dart';

main() async{
  final replay1 = ReplaySubject();
  final b1 = BehaviorSubject();
  final publish = PublishSubject();
  final b2 = BehaviorSubject<String>();

  futures() async {
    // await Observable(replay1)
    //     .pipe(b1)
    //     .then((i) => print(i))
    //     .catchError((e) => print(e));

    await Future.delayed(Duration(seconds: 2))
        .then((i) => print("next test..." + "$i"))
        .catchError((e) => print(e));

    await b2
   //     .windowTime(Duration(seconds: 3))
   //     .doOnData((i) => print("next..."))
        .flatMap((s) => Observable.just(s))
        .listen(print);
  }

  delay(int time) async {
    await Future.delayed(Duration(seconds: time)).catchError((e) => e);
  }

  publish.add("antes");
  publish.stream.listen(print); // só ouve os adicionados depois de ser ouvido

  publish.add("depois");
  publish.add("depois do depois");
/////////////
  replay1.add(1);
  replay1.add(3);
  replay1.add(2);

  //replay1.stream.listen(print);
  b1.stream.listen((i) => print("$i" + " ouvindo antes...behavior"));


  await delay(2);
  b1.add(5);
  b1.add(3);
  b1.add("doggo");
  b1.add("doguinho");
  b1.add("dogoso");
  b1.stream.listen((i) => print("$i" +
      " sla")); // printa replay(por causa do pipe) e ultimo valor do behavior
  replay1.stream.listen((i) => print(i + 5)).onError((e) => print(e));

  //b2.map((i) => i + " b2").listen(print);
  var bang = b2.map((i) => i + "1").max().timeout(Duration(seconds: 30)).then(print);
  bang.asStream().listen(print).onError((e) => print(e));
  b2.add("a");
  b2.add("b");
  b2.add("c");
  b2.add("d");

   await futures();
  // replay1.close();
  // b1.close();
  // b2.close();
  // publish.close();
}
