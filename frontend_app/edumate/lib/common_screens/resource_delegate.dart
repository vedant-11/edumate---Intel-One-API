import 'package:flutter/material.dart';

import '../model/resource.dart';

class ResourceSearch extends SearchDelegate<Resource?> {
  final List<Resource> resources;

  ResourceSearch(this.resources);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = resources.where((resource) {
      return resource.name.toLowerCase().contains(query.toLowerCase()) ||
          resource.domain.toLowerCase().contains(query.toLowerCase()) ||
          resource.tags
              .any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final resource = results[index];
        return ListTile(
          title: Text(resource.name),
          subtitle: Text(resource.domain),
          onTap: () {
            close(context, resource);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = resources.where((resource) {
      return resource.name.toLowerCase().contains(query.toLowerCase()) ||
          resource.domain.toLowerCase().contains(query.toLowerCase()) ||
          resource.tags
              .any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final resource = suggestions[index];
        return ListTile(
          title: Text(resource.name),
          subtitle: Text(resource.domain),
          onTap: () {
            query = resource.name;
            showResults(context);
          },
        );
      },
    );
  }
}
