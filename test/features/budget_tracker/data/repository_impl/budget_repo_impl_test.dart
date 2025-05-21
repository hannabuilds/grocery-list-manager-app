import 'package:grocery_list_manager/core/errors/failure.dart';
import 'package:grocery_list_manager/features/budget_tracker/data/repository_impl/budget_repo_impl.dart';
import 'package:grocery_list_manager/features/budget_tracker/domain/entities/budget.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

import 'budget_remote_datasource.mock.dart';


void main() {
  late BudgetRepositoryImplementation budgetRepositoryUnderTest;
  late MockBudgetRemoteDatasource mockBudgetRemoteDatasource;

  setUp(() {
    mockBudgetRemoteDatasource = MockBudgetRemoteDatasource();
    budgetRepositoryUnderTest = BudgetRepositoryImplementation(mockBudgetRemoteDatasource);
  });

    const tListId = 'list_1';
    const tBudgetId = '1';
    final tBudget = Budget(
      id: '1',
      amount: 500.0,
      listId: 'list_1',
    );


//setBudget
group('setBudget', () {
    test('should return Right(void) when the setBudget method is successful', () async {
      // Arrange
      when(() => mockBudgetRemoteDatasource.setBudget(tBudget))
          .thenAnswer((_) async {}); // Simulating success (void)

      // Act
      final result = await budgetRepositoryUnderTest.setBudget(tBudget);

      // Assert
      expect(result, equals(const Right(null)));
      verify(() => mockBudgetRemoteDatasource.setBudget(tBudget)).called(1);
      verifyNoMoreInteractions(mockBudgetRemoteDatasource);
    });

    test('should return Left(Failure) when the setBudget method throws an exception', () async {
      // Arrange
      when(() => mockBudgetRemoteDatasource.setBudget(tBudget))
          .thenThrow(Exception()); // Simulating an error

      // Act
      final result = await budgetRepositoryUnderTest.setBudget(tBudget);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockBudgetRemoteDatasource.setBudget(tBudget)).called(1);
      verifyNoMoreInteractions(mockBudgetRemoteDatasource);
    });
  });


//getBudgetByListId
group('getBudgetByListId', () {
    test('should return Right(Budget) when getBudgetByListId is successful', () async {
      // Arrange
      when(() => mockBudgetRemoteDatasource.getBudgetByListId(tListId))
          .thenAnswer((_) async => tBudget); // Simulating success

      // Act
      final result = await budgetRepositoryUnderTest.getBudgetByListId(tListId);

      // Assert
      expect(result, equals(Right(tBudget)));
      verify(() => mockBudgetRemoteDatasource.getBudgetByListId(tListId)).called(1);
      verifyNoMoreInteractions(mockBudgetRemoteDatasource);
    });

    test('should return Left(Failure) when getBudgetByListId throws an exception', () async {
      // Arrange
      when(() => mockBudgetRemoteDatasource.getBudgetByListId(tListId))
          .thenThrow(Exception()); // Simulating an error

      // Act
      final result = await budgetRepositoryUnderTest.getBudgetByListId(tListId);

      // Assert
      expect(result, isA<Left<Failure, Budget>>());
      verify(() => mockBudgetRemoteDatasource.getBudgetByListId(tListId)).called(1);
      verifyNoMoreInteractions(mockBudgetRemoteDatasource);
    });
  });


//updateBudget
 group('updateBudget', () {
    test('should return Right(void) when updateBudget is successful', () async {
      // Arrange
      when(() => mockBudgetRemoteDatasource.updateBudget(tBudget))
          .thenAnswer((_) async {}); // Simulating success (void)

      // Act
      final result = await budgetRepositoryUnderTest.updateBudget(tBudget);

      // Assert
      expect(result, equals(const Right(null)));
      verify(() => mockBudgetRemoteDatasource.updateBudget(tBudget)).called(1);
      verifyNoMoreInteractions(mockBudgetRemoteDatasource);
    });

    test('should return Left(Failure) when updateBudget throws an exception', () async {
      // Arrange
      when(() => mockBudgetRemoteDatasource.updateBudget(tBudget))
          .thenThrow(Exception()); // Simulating an error

      // Act
      final result = await budgetRepositoryUnderTest.updateBudget(tBudget);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockBudgetRemoteDatasource.updateBudget(tBudget)).called(1);
      verifyNoMoreInteractions(mockBudgetRemoteDatasource);
    });
  });


//deleteBudget
   group('deleteBudget', () {
    test('should return Right(void) when deleteBudget is successful', () async {
      // Arrange
      when(() => mockBudgetRemoteDatasource.deleteBudget(any()))
          .thenAnswer((_) async {}); // Simulating success (void)

      // Act
      final result = await budgetRepositoryUnderTest.deleteBudget(tBudgetId);

      // Assert
      expect(result, equals(const Right(null)));
      verify(() => mockBudgetRemoteDatasource.deleteBudget(tBudgetId)).called(1);
      verifyNoMoreInteractions(mockBudgetRemoteDatasource);
    });

    test('should return Left(Failure) when deleteBudget throws an exception', () async {
      // Arrange
      when(() => mockBudgetRemoteDatasource.deleteBudget(any()))
          .thenThrow(Exception()); // Simulating an error

      // Act
      final result = await budgetRepositoryUnderTest.deleteBudget(tBudgetId);

      // Assert
      expect(result, isA<Left<Failure, void>>());
      verify(() => mockBudgetRemoteDatasource.deleteBudget(tBudgetId)).called(1);
      verifyNoMoreInteractions(mockBudgetRemoteDatasource);
    });
  });
  
  
}

