import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:social_app/models/all_users_model.dart';
import 'package:social_app/services/dio.dart';
import 'package:social_app/services/shared.dart';
part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  static SearchCubit get(context) => BlocProvider.of(context);

  List<Data> searchRes = [];
  void searchUser(String q) {
    if (q.isEmpty) {
      searchRes.clear();
    } else {
      emit(SearchLoading());
      DioHelper.getData(
          url: 'users/search',
          token: CacheHelper.getData('token'),
          query: {'searchBox': q}).then((value) {
        AllUsers res = AllUsers.fromJson(value.data);
        if (res.status == true) {
          searchRes.clear();
          res.data?.forEach((element) {
            searchRes.add(element);
          });
          emit(SearchSuccess());
        } else {
          emit(SearchError());
        }
      }).catchError((e) {
        emit(SearchError());
      });
    }
  }
}
