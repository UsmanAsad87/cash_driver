import 'package:cash_driver/constants.dart';
import 'package:cash_driver/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({Key? key, required this.withdrawalAmount}) : super(key: key);
  final int? withdrawalAmount;

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Withdrawal'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        elevation: 2,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 25.sp, horizontal: 17.sp),
        children: [
          Text(
            'List of withdrawal.',
            style: GoogleFonts.poppins(
                color: kPrimaryColor,
                fontSize: 22.sp,
                fontWeight: FontWeight.w500),
          ),
          const Divider(color: kSecondaryColor),
          SizedBox(height: 40.sp),
          Align(
            alignment: Alignment.center,
            child: Text(
              'No current withdrawal',
              style: GoogleFonts.poppins(
                  color: kSecondaryColor,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: 100.sp),
          GestureDetector(
            onTap: withDrawal,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 9.sp, horizontal: 12.sp),
              margin: EdgeInsets.symmetric(horizontal: 60.r),
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(20.r)),
              ),
              child: Text(
                'Withdrawal Amount: ${widget.withdrawalAmount}',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    color: kPrimaryColor,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> withDrawal() async {
    if (widget.withdrawalAmount != 0) {
      // Create a connector
      final connector = WalletConnect(
        bridge: 'https://bridge.walletconnect.org',
        clientMeta: PeerMeta(
          name: 'WalletConnect',
          description: 'WalletConnect Developer App',
          url: 'https://walletconnect.org',
          icons: [
            'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
          ],
        ),
      );

// Subscribe to events
      connector.on('connect', (session) => print(session));
      connector.on('session_update', (payload) => print(payload));
      connector.on('disconnect', (session) => print(session));

// Create a new session
      if (!connector.connected) {
        final session = await connector.createSession(
          chainId: 4160,
          onDisplayUri: (uri) => print(uri),
        );
      }

//       final sender = Address.fromAlgorandAddress(address: session.accounts[0]);
//
// // Fetch the suggested transaction params
//       final params = await algorand.getSuggestedTransactionParams();
//
// // Build the transaction
//       final tx = await (PaymentTransactionBuilder()
//         ..sender = sender
//         ..noteText = 'Signed with WalletConnect'
//         ..amount = Algo.toMicroAlgos(0.0001)
//         ..receiver = sender
//         ..suggestedParams = params)
//           .build();
//
// // Sign the transaction
//       final signedBytes = await provider.signTransaction(
//         tx.toBytes(),
//         params: {
//           'message': 'Optional description message',
//         },
//       );
//
// // Broadcast the transaction
//       final txId = await algorand.sendRawTransactions(
//         signedBytes,
//         waitForConfirmation: true,
//       );

    } else {
      showToast('Your current balance is 0.');
    }
  }
}
