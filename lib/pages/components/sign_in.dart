import "package:best_before_app/UpdateDatabase.dart";
import 'package:best_before_app/notifications/NotifData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  await Firebase.initializeApp();

  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount == null) {
    // cancelled login
    print('Continue with Google: Error!');
    print('Return to Default Settings');
    return null;
  }

  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User user = authResult.user;
  userCol = user.uid;

  deleteOldData();

  if (user != null) {
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    userCol = user.uid;
    FirebaseMessaging.instance.subscribeToTopic(userCol);

    print('Continue with Google: Success');
    print('$user');

    getData();

    return '$user';
  }

  return null;
}

Future<void> signOutGoogle() async {
  _auth.signOut().then((_) async {
    await googleSignIn.signOut();
    FirebaseMessaging.instance.unsubscribeFromTopic(userCol);
    print('Continue with Google: Signed Out');
  });
}

void signInTestUser() {
  userCol = "THIS_IS_THE_TEST_USER";
}
