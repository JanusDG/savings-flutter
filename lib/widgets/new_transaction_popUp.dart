import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/home/home_bloc.dart';
import '../blocs/home/home_event.dart';
import '../blocs/home/home_state.dart';
import '../constants/transaction_constants.dart';
import '../repositories/transaction_reporitory.dart';

class NewTransactionPopUp extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  Future<dynamic>? futureNewTransactionResp;

  NewTransactionPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Container(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            onPressed: () {
              showNewTransactionPopUp(context, formKey);
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildLoginErrorPopUp(
      BuildContext context, String addTransactionPopUpText) {
    return AlertDialog(
      title: const Text(Transactionconstants.newTransactionError),
      content: Text(addTransactionPopUpText),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Ok'),
        ),
      ],
    );
  }

  void validateAddNewTransaction(BuildContext context, String wid, String cid,
      String delta, String description) {
    futureNewTransactionResp =
        getTranactionCreateResponce(wid, cid, delta, description);

    futureNewTransactionResp?.then((value) {
      if (value != "ok") {
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildLoginErrorPopUp(
                context, Transactionconstants.databaseError));
      }
    });
  }

  void showNewTransactionPopUp(
      BuildContext context, GlobalKey<FormState> formKey) {
    String categoryId = "";
    String walletId = "";
    String delta = "";
    String desc = "";
    showDialog(
      context: context,
      builder: (BuildContext newContext) {
        // context.read<HomeBloc>().add(FetchWallets());
        // return BlocBuilder<HomeBloc, HomeState>(
        //   builder: (context, state) {
        return AlertDialog(
          content: Stack(
            // overflow: Overflow.visible,
            children: [
              const Text("Add new Transaction"),
              Positioned(
                right: -40.0,
                top: -40.0,
                child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.close),
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onSaved: (String? value) {
                          walletId = value!;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Wallet Id",
                          hintText: "Number",
                          // icon: Icon(Icons.lock)
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onSaved: (String? value) {
                          categoryId = value!;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Category Id",
                          hintText: "1 or 2",
                          // icon: Icon(Icons.lock)
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onSaved: (String? value) {
                          delta = value!;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Amount",
                          hintText: "Number",
                          // icon: Icon(Icons.lock)
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onSaved: (String? value) {
                          desc = value!;
                        },
                        decoration: const InputDecoration(
                          labelText: "Enter description",
                          hintText: "Text",
                          // icon: Icon(Icons.lock)
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: const Text("Add"),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            validateAddNewTransaction(
                                context, walletId, categoryId, delta, desc);
                          }
                          context.read<HomeBloc>().add(FetchWallets());
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    // });
  }
}