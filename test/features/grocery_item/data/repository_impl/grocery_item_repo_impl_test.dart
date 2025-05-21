import 'package:grocery_list_manager/core/errors/failure.dart';
import 'package:grocery_list_manager/features/grocery_item/data/repository_impl/grocery_item_repo_impl.dart';
import 'package:grocery_list_manager/features/grocery_item/domain/entities/grocery_item.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

import 'grocery_item_remote_datasource.mock.dart';


void main() {
  late GroceryItemRepositoryImplementation groceryItemRepositoryUnderTest;
  late MockGroceryItemRemoteDatasource mockGroceryItemRemoteDatasource;

  setUp(() {
    mockGroceryItemRemoteDatasource = MockGroceryItemRemoteDatasource();
    groceryItemRepositoryUnderTest = GroceryItemRepositoryImplementation(mockGroceryItemRemoteDatasource);
  });

  const tItemId = '1';
  const tGroceryItem = GroceryItem(
    id: '1',
    name: 'Milk',
    quantity: 2,
    price: 5.50,
    listId: 'list_1',
  );

  const tListId = 'list_1';
  final tGroceryItems = [
    const GroceryItem(id: '1', name: 'Milk', quantity: 2, price: 5.50, listId: tListId),
    const GroceryItem(id: '2', name: 'Eggs', quantity: 12, price: 3.00, listId: tListId),
  ];


//addItem
  group('addItem', () {
    test('should return Right(void) when addItem is successful', () async {
      // Arrange
      when(() => mockGroceryItemRemoteDatasource.addItem(tGroceryItem))
          .thenAnswer((_) async {}); // Simulating success (void)

      // Act
      final result = await groceryItemRepositoryUnderTest.addItem(tGroceryItem);

      // Assert
      expect(result, equals(const Right(null)));
      verify(() => mockGroceryItemRemoteDatasource.addItem(tGroceryItem)).called(1);
      verifyNoMoreInteractions(mockGroceryItemRemoteDatasource);
    });

    test('should return Left(Failure) when addItem throws an exception', () async {
      // Arrange
      when(() => mockGroceryItemRemoteDatasource.addItem(tGroceryItem))
          .thenThrow(Exception()); // Simulating an error

      // Act
      final result = await groceryItemRepositoryUnderTest.addItem(tGroceryItem);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockGroceryItemRemoteDatasource.addItem(tGroceryItem)).called(1);
      verifyNoMoreInteractions(mockGroceryItemRemoteDatasource);
    });
  });


//deleteItem
group('deleteItem', () {
    test('should return Right(void) when deleteItem is successful', () async {
      // Arrange
      when(() => mockGroceryItemRemoteDatasource.deleteItem(tItemId))
          .thenAnswer((_) async {}); // Simulating success (void)

      // Act
      final result = await groceryItemRepositoryUnderTest.deleteItem(tItemId);

      // Assert
      expect(result, equals(const Right(null)));
      verify(() => mockGroceryItemRemoteDatasource.deleteItem(tItemId)).called(1);
      verifyNoMoreInteractions(mockGroceryItemRemoteDatasource);
    });

    test('should return Left(Failure) when deleteItem throws an exception', () async {
      // Arrange
      when(() => mockGroceryItemRemoteDatasource.deleteItem(tItemId))
          .thenThrow(Exception()); // Simulating an error

      // Act
      final result = await groceryItemRepositoryUnderTest.deleteItem(tItemId);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockGroceryItemRemoteDatasource.deleteItem(tItemId)).called(1);
      verifyNoMoreInteractions(mockGroceryItemRemoteDatasource);
    });
  });


//getItemsByistId
   group('getItemsByListId', () {
    test('should return Right(List<GroceryItem>) when getItemsByListId is successful', () async {
      // Arrange
      when(() => mockGroceryItemRemoteDatasource.getItemsByListId(tListId))
          .thenAnswer((_) async => tGroceryItems); // Simulating success

      // Act
      final result = await groceryItemRepositoryUnderTest.getItemsByListId(tListId);

      // Assert
      expect(result, equals(Right(tGroceryItems)));
      verify(() => mockGroceryItemRemoteDatasource.getItemsByListId(tListId)).called(1);
      verifyNoMoreInteractions(mockGroceryItemRemoteDatasource);
    });

    test('should return Left(Failure) when getItemsByListId throws an exception', () async {
      // Arrange
      when(() => mockGroceryItemRemoteDatasource.getItemsByListId(tListId))
          .thenThrow(Exception()); // Simulating failure

      // Act
      final result = await groceryItemRepositoryUnderTest.getItemsByListId(tListId);

      // Assert
      expect(result, isA<Left<Failure, List<GroceryItem>>>());
      verify(() => mockGroceryItemRemoteDatasource.getItemsByListId(tListId)).called(1);
      verifyNoMoreInteractions(mockGroceryItemRemoteDatasource);
    });
  });


//updateItem
  group('updateItem', () {
    test('should return Right(void) when updateItem is successful', () async {
      // Arrange
      when(() => mockGroceryItemRemoteDatasource.updateItem(tGroceryItem))
          .thenAnswer((_) async {}); // Simulating success (void)

      // Act
      final result = await groceryItemRepositoryUnderTest.updateItem(tGroceryItem);

      // Assert
      expect(result, equals(const Right(null)));
      verify(() => mockGroceryItemRemoteDatasource.updateItem(tGroceryItem)).called(1);
      verifyNoMoreInteractions(mockGroceryItemRemoteDatasource);
    });

    test('should return Left(Failure) when updateItem throws an exception', () async {
      // Arrange
      when(() => mockGroceryItemRemoteDatasource.updateItem(tGroceryItem))
          .thenThrow(Exception()); // Simulating failure

      // Act
      final result = await groceryItemRepositoryUnderTest.updateItem(tGroceryItem);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockGroceryItemRemoteDatasource.updateItem(tGroceryItem)).called(1);
      verifyNoMoreInteractions(mockGroceryItemRemoteDatasource);
    });
  });

}
