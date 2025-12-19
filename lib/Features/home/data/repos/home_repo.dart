import 'package:bookly/Features/home/data/models/books_model/books_model.dart';
import 'package:bookly/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<BooksModel>>> fetchBestSellerBooks();
  Future<Either<Failure, List<BooksModel>>> fetchFearturedBooks();
}
