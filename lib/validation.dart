


class Validation{
  String? validateUserName (String? value)
  {
    if(value!.isEmpty){
      return "username is required";
    }
    else if(value.length < 5){
      return "username must be at least 5 character";
    }
    return null;

  }

  String? validateTile (String? value)
  {
    if(value!.isEmpty){
      return "Title is required";
    }
    else if(value.length < 5){
      return "Title must be at least 5 character";
    }
    return null;

  }

  String? validateDescription (String? value)
  {
    if(value!.isEmpty){
      return "description is required";
    }
    else if(value.length < 5){
      return "description must be at least 10 character";
    }
    return null;

  }



  String? validatePrice (String? value)
  {
    if(value!.isEmpty){
      return "price is required";
    }
    return null;

  }

  String? validateEmail  (String? value) {
    // {
    //   if(value!.isEmpty || !value.contains("@")){
    //     return "Invalid Email";
    //   }
    //   return null;
    //
    // }

    {
      if (value!.isEmpty) {
        return "Enter email address";
      }
      String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
          "\\@" +
          "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
          "(" +
          "\\." +
          "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
          ")+";
      RegExp regExp = RegExp(p);

      if (regExp.hasMatch(value)) {
        return null;
      }
      return 'Email is not valid';
    }
  }

  String? validatePassword (String? value) {
    {
      if(value!.isEmpty){
        return "password is required";
      }
      else if(value.length < 5){
        return "password must be at least 5 character";
      }
      return null;

    }
  }

}