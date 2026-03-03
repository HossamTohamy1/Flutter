import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/category_provider.dart';
import '../../models/category_model.dart';

class CategoryFormScreen extends StatefulWidget {
  final Category? category;

  const CategoryFormScreen({Key? key, this.category}) : super(key: key);

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.category?.categoryName ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.category?.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.category != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Category' : 'New Category'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter category name';
                }
                if (value.length > 100) {
                  return 'Category name cannot exceed 100 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              maxLength: 500,
              validator: (value) {
                if (value != null && value.length > 500) {
                  return 'Description cannot exceed 500 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveCategory,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEdit ? 'Update Category' : 'Create Category'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final provider = Provider.of<CategoryProvider>(context, listen: false);
    final isEdit = widget.category != null;

    bool success;
    
    if (isEdit) {
      final request = UpdateCategoryRequest(
        categoryName: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
      );
      success = await provider.updateCategory(
        widget.category!.categoryId,
        request,
      );
    } else {
      final request = CreateCategoryRequest(
        categoryName: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
      );
      success = await provider.createCategory(request);
    }

    setState(() => _isLoading = false);

    if (context.mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit 
                ? 'Category updated successfully' 
                : 'Category created successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              provider.errorMessage ?? 'Failed to save category',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}