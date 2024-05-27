
import 'package:montero_cmsc23/models/organization_model.dart';

class Donor {
  String name;
  double donation;
  String status;
  Organization org;

  Donor(this.name, this.donation, this.status, this.org);
}