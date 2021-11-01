abstract class NewProductStates{}
class NewProductInitialState extends NewProductStates{}

class ProductImagePickedSuccessState extends NewProductStates {}

class ProductImagePickedErrorState extends NewProductStates {}

class NewProductProductLoadingState extends NewProductStates {}
class NewProductProductSuccessState extends NewProductStates {}
class NewProductProductErrorState extends NewProductStates {}

class CreateProductLoadingState extends NewProductStates {}

class CreateProductSuccessState extends NewProductStates {}

class CreateProductErrorState extends NewProductStates {}