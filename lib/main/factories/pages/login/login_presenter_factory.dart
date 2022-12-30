import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../usecases/usecases.dart';
import 'login.dart';

LoginPresenter makeLoginPresenter() {
  return StreamLoginPresenter(
    authentication: makeRemoteAuthentication(),
    validation: makeLoginValidation(),
  );
}
