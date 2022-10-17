import 'dart:math';

import 'package:example/screens/notes/models/models.dart';
import 'package:example/screens/notes/notes_bloc.dart';
import 'package:example/screens/notes/notes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stx_bloc_base/stx_bloc_base.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesBloc(repository: NotesRepository())..load(),
      child: const NotesView(),
    );
  }
}

class NotesView extends StatelessWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notesBloc = context.read<NotesBloc>();

    return RefreshIndicator(
      displacement: 100,
      onRefresh: notesBloc.loadAsyncFuture,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My notes'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        notesBloc.search(value);
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      notesBloc.filter(true);
                    },
                    icon: const Text('Odd'),
                  ),
                  IconButton(
                    onPressed: () {
                      notesBloc.filter(false);
                    },
                    icon: const Text('Even'),
                  )
                ],
              ),
            ),
            Expanded(
              child: BlocConsumer<NotesBloc,
                  NetworkFilterableListState<Note, bool>>(
                listener: (context, state) {
                  if (state.status.isFailure) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(
                            state.errorMsg,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                  }
                },
                builder: (context, state) {
                  switch (state.status) {
                    case NetworkStatus.success:
                    case NetworkStatus.failure:
                      return Scrollbar(
                        child: ListView.builder(
                          itemCount: state.visibleData.length,
                          itemBuilder: ((context, index) {
                            final item = state.visibleData[index];

                            return NoteItem(item: item);
                          }),
                        ),
                      );
                    default:
                      return const Text('loading');
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          children: [
            FloatingActionButton(
              onPressed: () {
                context.read<NotesBloc>().addItemAsync(
                      Note(
                        noteId: Random().nextInt(100),
                        message: 'New note',
                      ),
                    );
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

class NoteItem extends StatelessWidget {
  const NoteItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Note item;

  @override
  Widget build(BuildContext context) {
    final notesBloc = context.read<NotesBloc>();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            child: Text(item.noteId.toString()),
          ),
          Expanded(
            flex: 4,
            child: Text(item.message.toString()),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.createdDate.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () {
              notesBloc.editItemAsync(
                Note(
                  noteId: item.noteId,
                  message: '${item.message}e',
                ),
              );
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.purple,
            ),
          ),
          IconButton(
            onPressed: () {
              notesBloc.removeItemAsync(item);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
