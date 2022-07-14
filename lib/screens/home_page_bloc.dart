import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageBloc extends StatefulWidget {
  const HomePageBloc({Key? key}) : super(key: key);

  @override
  State<HomePageBloc> createState() => _HomePageBlocState();
}

class _HomePageBlocState extends State<HomePageBloc> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Testing Bloc"),
          ),
          body: BlocConsumer<CounterBloc, CounterState>(
            listener: (context, state) {
              // _controller.clear();
            },
            builder: (context, state) {
              final invalidValue =
                  state is CounterInvalidState ? state.invalidValue : '';

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Current Value is : ${state.value}",
                      style: const TextStyle(fontSize: 32),
                    ),
                    Visibility(
                      child: Text('Invalid Input: $invalidValue'),
                      visible: state is CounterInvalidState,
                    ),
                    TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: "Please Enter Value"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FloatingActionButton(
                          child: const Icon(Icons.add),
                          onPressed: () {
                            BlocProvider.of<CounterBloc>(context).add(IncrementEvent(value: _controller.text));
                          },
                        ),
                        const SizedBox(height: 8),
                        FloatingActionButton(
                          child: const Icon(Icons.remove),
                          onPressed: () {
                            BlocProvider.of<CounterBloc>(context).add(DecrementEvent(value: _controller.text));
                          },
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          )),
    );
  }
}

//=============================================================
// States Starts Here
@immutable
abstract class CounterState {
  final int value;

  const CounterState({required this.value});
}

class CounterValidState extends CounterState {
  const CounterValidState({
    required int validValue,
  }) : super(value: validValue);
}

class CounterInvalidState extends CounterState {
  final String invalidValue;

  const CounterInvalidState({
    required this.invalidValue,
    required int previousValue,
  }) : super(value: previousValue);
}

//=============================================================
// Events Starts Here
@immutable
abstract class CounterEvent {
  final String value;

  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent({required String value}) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent({required String value}) : super(value);
}

//=============================================================
// Bloc Starts Here
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterValidState(validValue: 0)) {
    on<IncrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);

      if (integer == null) {
        emit(CounterInvalidState(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      } else {
        emit(CounterValidState(validValue: state.value + integer));
      }
    });
    on<DecrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);

      if (integer == null) {
        emit(CounterInvalidState(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      } else {
        emit(CounterValidState(validValue: state.value - integer));
      }
    });
  }
}
