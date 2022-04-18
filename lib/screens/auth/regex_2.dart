void main() {
  String given_str = "asdlkj2#\$lsdk";

  String rSimplePasswordFormat = '^.[0-9a-zA-Z@#\\\$%^&-+=()]{6,20}\$';
  RegExp regex2 = RegExp(rSimplePasswordFormat);
  if (regex2.hasMatch(given_str)) {
    print('yes for Reg 2!');
  } else {
    if (given_str.length < 6 || given_str.length > 20) {
      print('Either too long or too short');
    }
//     if (!RegExp(rNoSpaces).hasMatch(given_str)) {
//       print ('No spaces allowed!');
//     }
    else {
      print(
          'Only alphabets, numbers and the symbols @#\\\$%^&)(-+= are allowed');
    }
    print('No');
  }

  // Then check if the email looks valid
  String _email = 'sdlfklk.sl@s.sdf';
  // String pattern = r'/^w+[+.w-]*@([w-]+.)*w+[w-]*.([a-z]{2,4}|d+)$/i';
  String pattern = r'^.{1,}@.{1,}\..{1,}$';
  RegExp regEx = RegExp(pattern);
  if (!regEx.hasMatch(_email)) {
    print("Email doesn't look valid");
  } else {
    print("Email looks fine");
  }
}
