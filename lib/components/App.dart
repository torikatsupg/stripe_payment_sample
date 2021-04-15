import 'package:flutter/material.dart';
import 'package:stripe_payment_sample/service/stripe_service.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stripe payment',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Stripe payment'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _buildContent(),
        ),
      ),
    );
  }

  /// コンテンツの描画
  Widget _buildContent() {
    return ListView.separated(
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return _buildPayViaNewCardButton(context);
          case 1:
            return _buildPayViaExistingCardButton(context);
          default:
            return Container();
        }
      },
      itemCount: 2,
      separatorBuilder: (
        context,
        index,
      ) =>
          Divider(color: Theme.of(context).primaryColor),
    );
  }

  /// 未登録のカードで決済をするボタン
  Widget _buildPayViaNewCardButton(BuildContext context) {
    return InkWell(
      child: ListTile(
        leading: Icon(
          Icons.add,
          color: Theme.of(context).primaryColor,
        ),
        title: Text('pay via new card'),
      ),
      onTap: StripeService().payViaNewCard,
    );
  }

  /// 登録済みのカードで決済をするボタン
  Widget _buildPayViaExistingCardButton(BuildContext context) {
    return InkWell(
      child: ListTile(
        leading: Icon(
          Icons.credit_card_outlined,
          color: Theme.of(context).primaryColor,
        ),
        title: Text('pay via existing card'),
      ),
      onTap: () => print('on tap'),
    );
  }
}
