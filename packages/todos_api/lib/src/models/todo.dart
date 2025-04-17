import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:todos_api/todos_api.dart';
import 'package:uuid/uuid.dart';

part 'todo.g.dart';

/// {@template todo_item}
/// Đối tượng Todo đại diện cho một công việc cần làm
///
/// Mỗi Todo bao gồm:
/// - [title]: Tiêu đề công việc
/// - [description]: Mô tả chi tiết (không bắt buộc)
/// - [id]: Định danh duy nhất
/// - [isCompleted]: Trạng thái hoàn thành
///
/// ID sẽ tự động được tạo nếu không được cung cấp.
/// Todo là immutable (không thể thay đổi trực tiếp) và có thể:
/// - Tạo bản sao với [copyWith]
/// - Chuyển đổi qua JSON với [toJson]/[fromJson]
/// {@endtemplate}
@immutable
@JsonSerializable()
class Todo extends Equatable {
  /// {@macro todo_item}
  Todo({
    required this.title,
    String? id,
    this.description = '',
    this.isCompleted = false,
  })  : assert(
          id == null || id.isNotEmpty,
          'id must either be null or not empty',
        ),
        id = id ?? const Uuid().v4();

  /// ID định danh duy nhất cho mỗi todo
  /// Không được để trống
  final String id;

  /// Tiêu đề của công việc
  /// Có thể để trống
  final String title;

  /// Mô tả chi tiết về công việc
  /// Mặc định là chuỗi rỗng
  final String description;

  /// Trạng thái hoàn thành của công việc
  /// true: đã hoàn thành, false: chưa hoàn thành
  /// Mặc định là false
  final bool isCompleted;

  /// Returns a copy of this `todo` with the given values updated.
  ///
  /// {@macro todo_item}
  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// Deserializes the given [JsonMap] into a [Todo].
  static Todo fromJson(JsonMap json) => _$TodoFromJson(json);

  /// Converts this [Todo] into a [JsonMap].
  JsonMap toJson() => _$TodoToJson(this);

  @override
  List<Object> get props => [id, title, description, isCompleted];
}
