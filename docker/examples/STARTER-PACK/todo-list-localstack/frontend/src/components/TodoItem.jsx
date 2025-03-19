import React from 'react';

const TodoItem = ({ todo, onDelete }) => {
  return (
    <div>
      <span>{todo.text}</span>
      <button onClick={() => onDelete(todo._id)}>Delete</button>
    </div>
  );
};

export default TodoItem;
