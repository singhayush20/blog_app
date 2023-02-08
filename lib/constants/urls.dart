import 'package:blog_app/constants/app_constants.dart';

const loginUrl = domain + "/blog/auth/login";

const registerUrl = domain + "/blog/auth/register";

const sendEmailVerificationOTPUrl = domain + "/blog/auth/sendotp";

const verifyEmailVerificationOTPUrl = domain + "/blog/auth/verify-otp";

const sendResetPasswordOTPUrl = domain + "/blog/auth/reset-password-otp";

const resetPasswordUrl = domain + "/blog/auth/reset-password";

const getUserDetailsUrl = domain + "/blog/users/get-user-by-email";

const updateUserProfileUrl = domain + "/blog/users/update-user";

const uploadArticleImageUrl =
    "/blog/posts/upload"; //domain will be added separately

const createPostUrl = domain + "/blog/posts/create";

const getAllCategoriesUrl = domain + "/blog/categories/get-all";

const getAllPostsByUserUrl = domain + "/blog/posts/get-post-by-user";

const getAllCommentsByPostUrl = domain + "/blog/comments/get-comments-by-post";

const deletePostUrl = domain + "/blog/posts/delete";

const updatePostUrl = domain + "/blog/posts/update";
