class CreateChatId{
  int firstLetter =0;
  int secondLetter=1;

  getChatID(String firstUser, String secondUser) {

    if (firstUser.substring(firstLetter, secondLetter).codeUnitAt(0) > secondUser.substring(firstLetter, secondLetter).codeUnitAt(0)) {
      return '$firstUser\_$secondUser';
    } else if (firstUser.substring(firstLetter, secondLetter).codeUnitAt(0) == secondUser.substring(firstLetter, secondLetter).codeUnitAt(0)) {
      firstLetter++;
      secondLetter++;
      getChatID(firstUser, secondUser);

    }else{

      return '$secondUser\_$firstUser';
    }
  }
}