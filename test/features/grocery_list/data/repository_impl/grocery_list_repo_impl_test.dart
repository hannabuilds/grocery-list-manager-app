import 'package:grocery_list_manager/core/errors/failure.dart';
import 'package:grocery_list_manager/features/grocery_list/data/repository_impl/grocery_list_repo_impl.dart';
import 'package:grocery_list_manager/features/grocery_list/domain/entities/grocery_list.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

import 'grocery_list_remote_datasource.mock.dart';


void main() {
  late GroceryListRepositoryImplementation groceryListRepositoryUnderTest;
  late MockGroceryListRemoteDatasource mockGroceryListRemoteDatasource;

  setUp(() {
    mockGroceryListRemoteDatasource = MockGroceryListRemoteDatasource();
    groceryListRepositoryUnderTest = GroceryListRepositoryImplementation(mockGroceryListRemoteDatasource);
  });

  const tGroceryListId = '1';
  const tGroceryList = GroceryList(
    id: '1',
    name: 'Weekly Groceries',
    items: ['item1', 'item2'],
  );

  final tGroceryLists = [
    tGroceryList,
    const GroceryList(id: '1', name: 'Monthly Groceries', items: ['item3']),
  ];


//addGroceryList
  group('addGroceryList', () {
    test('should return Right(void) when addGroceryList is successful', () async {
      // Arrange
      when(() => mockGroceryListRemoteDatasource.addGroceryList(tGroceryList))
          .thenAnswer((_) async {}); // Simulating success (void return)

      // Act
      final result = await groceryListRepositoryUnderTest.addGroceryList(tGroceryList);

      // Assert
      expect(result, equals(const Right(null)));
      verify(() => mockGroceryListRemoteDatasource.addGroceryList(tGroceryList)).called(1);
      verifyNoMoreInteractions(mockGroceryListRemoteDatasource);
    });

    test('should return Left(Failure) when addGroceryList throws an exception', () async {
      // Arrange
      when(() => mockGroceryListRemoteDatasource.addGroceryList(tGroceryList))
          .thenThrow(Exception()); // Simulating failure

      // Act
      final result = await groceryListRepositoryUnderTest.addGroceryList(tGroceryList);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockGroceryListRemoteDatasource.addGroceryList(tGroceryList)).called(1);
      verifyNoMoreInteractions(mockGroceryListRemoteDatasource);
    });
  });


//deleteGroceryList
group('deleteGroceryList', () {
    test('should return Right(void) when deleteGroceryList is successful', () async {
      // Arrange
      when(() => mockGroceryListRemoteDatasource.deleteGroceryList(tGroceryListId))
          .thenAnswer((_) async {}); // Simulating success (void return)

      // Act
      final result = await groceryListRepositoryUnderTest.deleteGroceryList(tGroceryListId);

      // Assert
      expect(result, equals(const Right(null)));
      verify(() => mockGroceryListRemoteDatasource.deleteGroceryList(tGroceryListId)).called(1);
      verifyNoMoreInteractions(mockGroceryListRemoteDatasource);
    });

    test('should return Left(Failure) when deleteGroceryList throws an exception', () async {
      // Arrange
      when(() => mockGroceryListRemoteDatasource.deleteGroceryList(tGroceryListId))
          .thenThrow(Exception()); // Simulating failure

      // Act
      final result = await groceryListRepositoryUnderTest.deleteGroceryList(tGroceryListId);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockGroceryListRemoteDatasource.deleteGroceryList(tGroceryListId)).called(1);
      verifyNoMoreInteractions(mockGroceryListRemoteDatasource);
    });
  });


//getAllGroceryLists
group('getAllGroceryLists', () {
    test('should return Right(List<GroceryList>) when getAllGroceryLists is successful', () async {
      // Arrange
      when(() => mockGroceryListRemoteDatasource.getAllGroceryLists())
          .thenAnswer((_) async => tGroceryLists); // Simulating successful data retrieval

      // Act
      final result = await groceryListRepositoryUnderTest.getAllGroceryLists();

      // Assert
      expect(result, equals(Right(tGroceryLists)));
      verify(() => mockGroceryListRemoteDatasource.getAllGroceryLists()).called(1);
      verifyNoMoreInteractions(mockGroceryListRemoteDatasource);
    });

    test('should return Left(Failure) when getAllGroceryLists throws an exception', () async {
      // Arrange
      when(() => mockGroceryListRemoteDatasource.getAllGroceryLists())
          .thenThrow(Exception()); // Simulating failure

      // Act
      final result = await groceryListRepositoryUnderTest.getAllGroceryLists();

      // Assert
      expect(result, isA<Left<Failure, List<GroceryList>>>());
      verify(() => mockGroceryListRemoteDatasource.getAllGroceryLists()).called(1);
      verifyNoMoreInteractions(mockGroceryListRemoteDatasource);
    });
  });


//updateGroceryList
  group('updateGroceryList', () {
    test('should return Right(void) when updateGroceryList is successful', () async {
      // Arrange
      when(() => mockGroceryListRemoteDatasource.updateGroceryList(tGroceryList))
          .thenAnswer((_) async {}); // Simulating success (void return)

      // Act
      final result = await groceryListRepositoryUnderTest.updateGroceryList(tGroceryList);

      // Assert
      expect(result, equals(const Right(null)));
      verify(() => mockGroceryListRemoteDatasource.updateGroceryList(tGroceryList)).called(1);
      verifyNoMoreInteractions(mockGroceryListRemoteDatasource);
    });

    test('should return Left(Failure) when updateGroceryList throws an exception', () async {
      // Arrange
      when(() => mockGroceryListRemoteDatasource.updateGroceryList(tGroceryList))
          .thenThrow(Exception()); // Simulating failure

      // Act
      final result = await groceryListRepositoryUnderTest.updateGroceryList(tGroceryList);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockGroceryListRemoteDatasource.updateGroceryList(tGroceryList)).called(1);
      verifyNoMoreInteractions(mockGroceryListRemoteDatasource);
    });
  });
}
