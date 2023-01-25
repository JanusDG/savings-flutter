import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_flutter/constants/app_strings.dart';

import '../blocs/home/home_bloc.dart';
import '../blocs/home/home_event.dart';
import '../blocs/home/home_state.dart';
import '../constants/transaction_constants.dart';
import '../models/category.dart';
import '../models/wallet.dart';
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

  AlertDialog _buildLoginErrorPopUp(
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

  void _showErrorPopUp(BuildContext context, String addTransactionPopUpText) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            _buildLoginErrorPopUp(context, addTransactionPopUpText));
  }

  void validateAddNewTransaction(BuildContext context, Wallet? wallet,
      Category? category, String delta, String description) {
    if (wallet == null) {
      _showErrorPopUp(context, AppStrings.emptyError(AppStrings.wallet));
    } else if (category == null) {
      _showErrorPopUp(context, AppStrings.emptyError(AppStrings.category));
    } else if (delta == '') {
      _showErrorPopUp(context, AppStrings.numberError(AppStrings.delta));
    } else {
      futureNewTransactionResp = getTranactionCreateResponce(
          wallet.id.toString(),
          category.id.toString(),
          category.isIncome ? delta : "-$delta",
          description);

      futureNewTransactionResp?.then((value) {
        if (value != "ok") {
          _showErrorPopUp(context, Transactionconstants.databaseError);
        } else {
          context.read<HomeBloc>().add(FetchWallets());
          Navigator.of(context).pop();
        }
      });
    }
  }

  void showNewTransactionPopUp(
      BuildContext context, GlobalKey<FormState> formKey) {
    String delta = "";
    String desc = "";
    showDialog(
      context: context,
      builder: (BuildContext newContext) {
        Wallet? wallet;
        Category? category;
        // context.read<HomeBloc>().add(FetchWallets());
        // return BlocBuilder<HomeBloc, HomeState>(
        //   builder: (context, state) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add new Transaction",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  CloseButton(
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    StatefulBuilder(builder: (_, StateSetter setState) {
                      return Column(children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<Wallet>(
                              value: wallet,
                              hint: const Text(AppStrings.wallet),
                              isExpanded: true,
                              onChanged: (Wallet? value) {
                                setState(() {
                                  wallet = value!;
                                });
                              },
                              items: context
                                  .read<HomeBloc>()
                                  .wallets
                                  .map<DropdownMenuItem<Wallet>>(
                                      (Wallet value) {
                                return DropdownMenuItem<Wallet>(
                                  value: value,
                                  child: Text(value.name),
                                );
                              }).toList(),
                            )),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<Category>(
                              value: category,
                              hint: const Text(AppStrings.category),
                              isExpanded: true,
                              onChanged: (Category? value) {
                                setState(() {
                                  category = value!;
                                });
                              },
                              items: context
                                  .read<HomeBloc>()
                                  .categories
                                  .map<DropdownMenuItem<Category>>(
                                      (Category value) {
                                return DropdownMenuItem<Category>(
                                  value: value,
                                  child: Text(
                                    value.name,
                                    style: TextStyle(
                                        color: value.isIncome
                                            ? Colors.green
                                            : Colors.red),
                                  ),
                                );
                              }).toList(),
                            )),
                      ]);
                    }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onSaved: (String? value) {
                          double? parsed = double.tryParse(value!);
                          if (parsed != null) {
                            delta = (parsed * 10).abs().toString();
                          }
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: AppStrings.delta,
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
                          labelText: AppStrings.description,
                          // icon: Icon(Icons.lock)
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ElevatedButton(
                        child: const Text(AppStrings.addBtn),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            validateAddNewTransaction(
                                context, wallet, category, delta, desc);
                          }
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
