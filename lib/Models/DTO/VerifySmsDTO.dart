enum VerifySms { COMPLETED, FAILED, CODESENT, TIMEOUT }

class VerifySmsDTO {
  VerifySms? status;

  VerifySmsDTO({this.status});
}
