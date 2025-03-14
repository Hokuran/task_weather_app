import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../task/presentation/bloc/task_bloc.dart';
import '../../../weather/presentation/bloc/weather_bloc.dart';
import '../../../task/domain/entities/task.dart';
import '../widgets/task_item.dart';
import '../widgets/weather_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedCategory;
  bool? selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task & Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<WeatherBloc>().add(RefreshWeather());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Weather Widget
          BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherLoading) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state is WeatherError) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Weather Error: ${state.message}'),
                );
              } else if (state is WeatherLoaded) {
                return WeatherWidget(weather: state.weather);
              } else {
                return const SizedBox.shrink();
              }
            },
          ),

          // Filters
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Фільтри:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        DropdownButton<String>(
                          hint: const Text('Категорія'),
                          value: selectedCategory,
                          items: const [
                            DropdownMenuItem(value: '', child: Text('Всі')),
                            DropdownMenuItem(
                                value: 'Робота', child: Text('Робота')),
                            DropdownMenuItem(
                                value: 'Особисте', child: Text('Особисте')),
                            DropdownMenuItem(
                                value: 'Покупки', child: Text('Покупки')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value;
                              context.read<TaskBloc>().add(
                                    FilterTasks(
                                        status: selectedStatus,
                                        category: selectedCategory),
                                  );
                            });
                          },
                        ),
                        const SizedBox(width: 16),
                        DropdownButton<bool?>(
                          hint: const Text('Статус'),
                          value: selectedStatus,
                          items: const [
                            DropdownMenuItem(value: null, child: Text('Всі')),
                            DropdownMenuItem(
                                value: true, child: Text('Виконані')),
                            DropdownMenuItem(
                                value: false, child: Text('Не виконані')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedStatus = value;
                              context.read<TaskBloc>().add(
                                    FilterTasks(
                                        status: selectedStatus,
                                        category: selectedCategory),
                                  );
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Task List
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TaskError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is TaskLoaded) {
                  return state.filteredTasks.isEmpty
                      ? const Center(child: Text('Немає завдань'))
                      : ListView.builder(
                          itemCount: state.filteredTasks.length,
                          itemBuilder: (context, index) {
                            return TaskItem(
                              task: state.filteredTasks[index],
                              onToggle: (task) {
                                final updatedTask = MyTask(
                                  id: task.id,
                                  title: task.title,
                                  description: task.description,
                                  category: task.category,
                                  isCompleted: !task.isCompleted,
                                );
                                context
                                    .read<TaskBloc>()
                                    .add(UpdateTaskEvent(updatedTask));
                              },
                              onDelete: (id) {
                                context
                                    .read<TaskBloc>()
                                    .add(DeleteTaskEvent(id));
                              },
                            );
                          },
                        );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-task');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
