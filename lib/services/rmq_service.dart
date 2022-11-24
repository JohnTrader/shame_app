import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/material.dart';

class RMQService{
  final String userQueue = "TMDG2022";
  final String passQueue = "TMDG2022";
  final String VhostQueue = "/TMDG2022";
  final String hostQueue = "rmq2.pptik.id";

  String subscribedata(){
    String payload = "";
    ConnectionSettings settings = new ConnectionSettings(
      host: hostQueue,
      authProvider: new PlainAuthenticator(userQueue, passQueue),
      virtualHost: VhostQueue,
      //host: 'rmq2.pptik.id',
      //authProvider: PlainAuthenticator(widget.user, widget.pass),
      //virtualHost: widget.vhost,
    );
    Client client = new Client(settings: settings);
    client
        .channel()
        .then((Channel channel) => channel.queue("Sensor_PZEM004T",durable: true))
        .then((Queue queue) => queue.consume())
        .then((Consumer consumer) => consumer.listen((AmqpMessage message) {
      print("Diterima ${message.payloadAsString}");
      payload = message.payloadAsString;
    }));

    return payload;
  }
}