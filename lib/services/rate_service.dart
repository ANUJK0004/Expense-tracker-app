import 'package:in_app_review/in_app_review.dart';

class RateService {

  static Future<void> rateApp() async {

    final review = InAppReview.instance;

    if(await review.isAvailable()){

      review.requestReview();

    }else{

      review.openStoreListing();

    }

  }

}