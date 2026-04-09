import 'package:flutter/material.dart';
import '../../routes/navigation.dart';
import '/core/error/exceptions.dart';
import '/core/error/failures.dart';
import '/core/presentation/view_util.dart';
import '/core/presentation/widgets/error_dialog.dart';
import '/core/theme/app_colors.dart';

/// A mixin that provides error handling methods for presentation layer
mixin ErrorHandlerMixin {
  /// Show appropriate error UI based on failure type
  void handleError(Failure error, {BuildContext? context}) {
    if (error is ValidationFailure) {
      _showValidationErrorDialog(error, context: context);
    } else if (error is TooManyRequestsFailure) {
      _showTooManyRequestsDialog(error.message, context: context);
    } else if (error is AuthenticationFailure ||
        error is UnauthorizedException) {
      _makeUnauthorizedDecision(error.message, context: context);
    } else if (error is ServerFailure || error is ServerException) {
      _showServerErrorSnackBar(error.message, context: context);
    } else if (error is NetworkFailure || error is NetworkException) {
      _showNetworkErrorSnackBar(error.message, context: context);
    } else {
      ViewUtil.snackbar(error.message, context: context);
    }
  }

  /// Make decision for authentication errors
  void _makeUnauthorizedDecision(String message, {BuildContext? context}) {
    // Navigation.pushAndRemoveUntil(
    //   context ?? Navigation.key.currentContext,
    //   appRoutes: AppRoutes.login,
    // );
  }

  /// Show snackbar for server errors
  void _showServerErrorSnackBar(String message, {BuildContext? context}) {
    ViewUtil.snackbar(
      message,
      context: context ?? Navigation.key.currentContext,
    );
  }

  /// Show snackbar for network errors
  void _showNetworkErrorSnackBar(String message, {BuildContext? context}) {
    ViewUtil.snackbar(
      message,
      context: context ?? Navigation.key.currentContext,
    );
  }

  /// Show dialog for validation errors with all error messages
  void _showValidationErrorDialog(
    ValidationFailure failure, {
    BuildContext? context,
  }) {
    ViewUtil.alertDialog(
      context: context ?? Navigation.key.currentContext,
      alertBackgroundColor: AppColors.white.color,
      content: ErrorDialog(erroMsg: failure.errorMessages),
    );
  }

  /// Show dialog for too many requests errors
  void _showTooManyRequestsDialog(String message, {BuildContext? context}) {
    ViewUtil.alertDialog(
      context: context ?? Navigation.key.currentContext,
      alertBackgroundColor: AppColors.white.color,
      content: ErrorDialog(erroMsg: [message]),
    );
  }
}
