import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Product? _editedProduct;
  var isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      final id = ModalRoute.of(context)!.settings.arguments as String?;
      if (id != null) {
        _editedProduct = Provider.of<Products>(
          context,
          listen: false,
        ).findById(id);
        _imageUrlController.text = _editedProduct?.imageUrl ?? '';
      }
      isInit = false;
    }
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      final value = _imageUrlController.text;
      if (!value.startsWith('http')) {
        return;
      }
      if (!value.endsWith('.png') &&
          !value.endsWith('.jpg') &&
          !value.endsWith('.jpeg')) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _imageFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.dispose();
  }

  void finishEdit() {
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  Future<void> _saveForm() async {
    if (_form.currentState?.validate() ?? false) {
      _form.currentState?.save();
      setState(() {
        _isLoading = true;
      });
      if (_editedProduct != null) {
        if (_editedProduct!.id == '') {
          try {
            await Provider.of<Products>(context, listen: false)
                .addProduct(_editedProduct!);
          } catch (e) {
            await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('An error occured'),
                content: const Text('Something went wrong'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Ok'),
                  )
                ],
              ),
            );
          }
        } else {
          await Provider.of<Products>(context, listen: false)
              .updateProduct(_editedProduct!);
        }
        finishEdit();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _editedProduct?.title,
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        _priceFocusNode.requestFocus();
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct?.id ?? '',
                          title: value ?? '',
                          description: _editedProduct?.description ?? '',
                          price: _editedProduct?.price ?? 0,
                          imageUrl: _editedProduct?.imageUrl ?? '',
                          isFavorite: _editedProduct?.isFavorite ?? false,
                        );
                      },
                      validator: (value) {
                        return value?.isEmpty ?? false
                            ? 'Please provide a title'
                            : null;
                      },
                    ),
                    TextFormField(
                      initialValue: _editedProduct?.price.toString(),
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        _descFocusNode.requestFocus();
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct?.id ?? '',
                          title: _editedProduct?.title ?? '',
                          description: _editedProduct?.description ?? '',
                          price:
                              double.parse(value?.replaceAll(',', '.') ?? '0'),
                          imageUrl: _editedProduct?.imageUrl ?? '',
                          isFavorite: _editedProduct?.isFavorite ?? false,
                        );
                      },
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please provide a price';
                        }
                        if (double.tryParse(value!) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than 0';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _editedProduct?.description,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      onFieldSubmitted: (_) {
                        _priceFocusNode.requestFocus();
                      },
                      focusNode: _descFocusNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct?.id ?? '',
                          title: _editedProduct?.title ?? '',
                          description: value ?? '',
                          price: _editedProduct?.price ?? 0,
                          imageUrl: _editedProduct?.imageUrl ?? '',
                          isFavorite: _editedProduct?.isFavorite ?? false,
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text(
                                  'Enter a URL',
                                )
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Image URL',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                              setState(() {});
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct?.id ?? '',
                                title: _editedProduct?.title ?? '',
                                description: _editedProduct?.description ?? '',
                                price: _editedProduct?.price ?? 0,
                                imageUrl: value ?? '',
                                isFavorite: _editedProduct?.isFavorite ?? false,
                              );
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an image URL';
                              }
                              if (!value.startsWith('http')) {
                                return 'Please enter a valid URL';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid image URL';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
