import 'package:go_router/go_router.dart';
import '../models/product.dart';
import '../pages/add_product.dart';
import '../pages/detail_product.dart';
import '../pages/login.dart';
import '../pages/products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/error.dart';
import '../pages/home.dart';

export 'package:go_router/go_router.dart';
part 'route_name.dart';

final GoRouter router = GoRouter(
  redirect: (context, state) {
    FirebaseAuth auth = FirebaseAuth.instance;
    // Cek kondisi saat ini => sedang auth tidak?
    if (auth.currentUser == null) {
      // tidak sedang login, maka arahkan ke halaman login
      return "/login";
    } else {
      return null;
    }
  },
  errorBuilder: (context, state) => ErrorPage(),
  routes: [
    GoRoute(
      path: '/',
      name: Routes.home,
      builder: (context, state) => HomePage(),
      routes: [
        GoRoute(
          path: 'products',
          name: Routes.products,
          builder: (context, state) => ProductsPage(),
          routes: [
            GoRoute(
              path: ':productId',
              name: Routes.detailProduct,
              builder: (context, state) => DetailProduct(
                id: state.pathParameters['productId'].toString(),
                data: state.extra as Product,
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'add-product',
          name: Routes.addProduct,
          builder: (context, state) => AddProductPage(),
        ),
        // GoRoute(
        //   path: 'scanQr',
        //   name: Routes.scanQr,
        //   builder: (context, state) => QrScannerPage(),
        // ),
      ],
    ),
    GoRoute(
      path: '/login',
      name: Routes.login,
      builder: (context, state) => LoginPage(),
    ),
  ],
);
