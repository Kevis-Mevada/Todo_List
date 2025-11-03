// Todo List Application JavaScript
class TodoApp {
  constructor() {
    this.todos = this.loadTodos();
    this.currentFilter = "all";
    this.currentSort = "date";
    this.init();
  }

  init() {
    this.bindEvents();
    this.render();
    this.updateCounts();
    this.updateProgress();
  }

  bindEvents() {
    // Form submission
    document.getElementById("todo-form").addEventListener("submit", (e) => {
      e.preventDefault();
      this.addTodo();
    });

    // Filter buttons
    document.querySelectorAll("[data-filter]").forEach((button) => {
      button.addEventListener("click", (e) => {
        this.setFilter(e.target.dataset.filter);
      });
    });

    // Sort buttons
    document.querySelectorAll("[data-sort]").forEach((button) => {
      button.addEventListener("click", (e) => {
        this.setSortBy(e.target.dataset.sort);
      });
    });

    // Clear completed button
    document.getElementById("clear-completed").addEventListener("click", () => {
      this.clearCompleted();
    });

    // Keyboard shortcuts
    document.addEventListener("keydown", (e) => {
      if (e.ctrlKey && e.key === "Enter") {
        document.getElementById("task-input").focus();
      }
    });
  }

  addTodo() {
    const taskInput = document.getElementById("task-input");
    const prioritySelect = document.getElementById("priority-select");

    const text = taskInput.value.trim();
    if (!text) return;

    const todo = {
      id: Date.now().toString(),
      text: text,
      completed: false,
      priority: prioritySelect.value,
      createdAt: new Date().toISOString(),
      completedAt: null,
    };

    this.todos.unshift(todo);
    this.saveTodos();
    this.render();
    this.updateCounts();
    this.updateProgress();

    // Reset form
    taskInput.value = "";
    prioritySelect.value = "medium";
    taskInput.focus();

    // Show success feedback
    this.showToast("Task added successfully!", "success");
  }

  deleteTodo(id) {
    const todoIndex = this.todos.findIndex((todo) => todo.id === id);
    if (todoIndex === -1) return;

    const todo = this.todos[todoIndex];

    // Show confirmation for important tasks
    if (todo.priority === "high" && !todo.completed) {
      if (
        !confirm(
          "This is a high priority task. Are you sure you want to delete it?"
        )
      ) {
        return;
      }
    }

    this.todos.splice(todoIndex, 1);
    this.saveTodos();
    this.render();
    this.updateCounts();
    this.updateProgress();

    this.showToast("Task deleted!", "warning");
  }

  toggleTodo(id) {
    const todo = this.todos.find((todo) => todo.id === id);
    if (!todo) return;

    todo.completed = !todo.completed;
    todo.completedAt = todo.completed ? new Date().toISOString() : null;

    this.saveTodos();
    this.render();
    this.updateCounts();
    this.updateProgress();

    const message = todo.completed
      ? "Task completed! 🎉"
      : "Task marked as pending";
    const type = todo.completed ? "success" : "info";
    this.showToast(message, type);
  }

  editTodo(id) {
    const todo = this.todos.find((todo) => todo.id === id);
    if (!todo) return;

    const newText = prompt("Edit task:", todo.text);
    if (newText === null || newText.trim() === "") return;

    todo.text = newText.trim();
    this.saveTodos();
    this.render();

    this.showToast("Task updated!", "info");
  }

  setFilter(filter) {
    this.currentFilter = filter;

    // Update active button
    document.querySelectorAll("[data-filter]").forEach((btn) => {
      btn.classList.remove("active");
    });
    document.querySelector(`[data-filter="${filter}"]`).classList.add("active");

    this.render();
  }

  setSortBy(sortBy) {
    this.currentSort = sortBy;
    this.render();

    // Visual feedback for sort button
    const sortBtn = document.querySelector(`[data-sort="${sortBy}"]`);
    sortBtn.classList.add("loading");
    setTimeout(() => sortBtn.classList.remove("loading"), 500);
  }

  clearCompleted() {
    const completedCount = this.todos.filter((todo) => todo.completed).length;

    if (completedCount === 0) {
      this.showToast("No completed tasks to clear!", "info");
      return;
    }

    if (confirm(`Delete ${completedCount} completed task(s)?`)) {
      this.todos = this.todos.filter((todo) => !todo.completed);
      this.saveTodos();
      this.render();
      this.updateCounts();
      this.updateProgress();

      this.showToast(`${completedCount} completed task(s) cleared!`, "success");
    }
  }

  getFilteredTodos() {
    let filtered = [...this.todos];

    // Apply filter
    switch (this.currentFilter) {
      case "pending":
        filtered = filtered.filter((todo) => !todo.completed);
        break;
      case "completed":
        filtered = filtered.filter((todo) => todo.completed);
        break;
      default:
        // 'all' - no filtering needed
        break;
    }

    // Apply sorting
    switch (this.currentSort) {
      case "priority":
        const priorityOrder = { high: 3, medium: 2, low: 1 };
        filtered.sort((a, b) => {
          if (a.completed !== b.completed) {
            return a.completed - b.completed; // Put incomplete tasks first
          }
          return priorityOrder[b.priority] - priorityOrder[a.priority];
        });
        break;
      case "date":
      default:
        filtered.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
        break;
    }

    return filtered;
  }

  render() {
    const todoList = document.getElementById("todo-list");
    const emptyState = document.getElementById("empty-state");
    const filteredTodos = this.getFilteredTodos();

    if (filteredTodos.length === 0) {
      todoList.innerHTML = "";
      emptyState.classList.remove("d-none");
      return;
    }

    emptyState.classList.add("d-none");

    todoList.innerHTML = filteredTodos
      .map((todo) => this.createTodoHTML(todo))
      .join("");

    // Bind event listeners for the new elements
    todoList.querySelectorAll(".todo-checkbox").forEach((checkbox) => {
      checkbox.addEventListener("change", (e) => {
        this.toggleTodo(e.target.dataset.id);
      });
    });

    todoList.querySelectorAll(".btn-delete").forEach((button) => {
      button.addEventListener("click", (e) => {
        this.deleteTodo(e.target.dataset.id);
      });
    });

    todoList.querySelectorAll(".btn-edit").forEach((button) => {
      button.addEventListener("click", (e) => {
        this.editTodo(e.target.dataset.id);
      });
    });
  }

  createTodoHTML(todo) {
    const createdDate = new Date(todo.createdAt).toLocaleDateString();
    const createdTime = new Date(todo.createdAt).toLocaleTimeString([], {
      hour: "2-digit",
      minute: "2-digit",
    });

    return `
            <div class="list-group-item todo-item ${
              todo.completed ? "completed" : ""
            }" data-id="${todo.id}">
                <div class="d-flex align-items-center">
                    <input type="checkbox" 
                           class="form-check-input todo-checkbox" 
                           ${todo.completed ? "checked" : ""} 
                           data-id="${todo.id}">
                    
                    <div class="flex-grow-1">
                        <p class="task-text mb-1">${this.escapeHtml(
                          todo.text
                        )}</p>
                        <div class="d-flex align-items-center gap-2">
                            <span class="priority-badge priority-${
                              todo.priority
                            }">
                                ${todo.priority.toUpperCase()}
                            </span>
                            <small class="task-date text-muted">
                                <i class="bi bi-calendar3 me-1"></i>
                                ${createdDate} at ${createdTime}
                            </small>
                            ${
                              todo.completed
                                ? `
                                <small class="text-success">
                                    <i class="bi bi-check-circle-fill me-1"></i>
                                    Completed
                                </small>
                            `
                                : ""
                            }
                        </div>
                    </div>
                    
                    <div class="d-flex gap-1">
                        <button class="btn-edit" data-id="${
                          todo.id
                        }" title="Edit task">
                            <i class="bi bi-pencil"></i>
                        </button>
                        <button class="btn-delete" data-id="${
                          todo.id
                        }" title="Delete task">
                            <i class="bi bi-trash"></i>
                        </button>
                    </div>
                </div>
            </div>
        `;
  }

  updateCounts() {
    const total = this.todos.length;
    const completed = this.todos.filter((todo) => todo.completed).length;
    const pending = total - completed;

    document.getElementById("task-count").textContent = total;
    document.getElementById("all-count").textContent = total;
    document.getElementById("pending-count").textContent = pending;
    document.getElementById("completed-count").textContent = completed;
  }

  updateProgress() {
    const total = this.todos.length;
    const completed = this.todos.filter((todo) => todo.completed).length;
    const percentage = total === 0 ? 0 : Math.round((completed / total) * 100);

    const progressBar = document.getElementById("progress-bar");
    const progressText = document.getElementById("progress-text");

    progressBar.style.width = `${percentage}%`;
    progressText.textContent = `${percentage}% completed (${completed}/${total})`;

    // Change progress bar color based on completion
    progressBar.className = "progress-bar";
    if (percentage === 100 && total > 0) {
      progressBar.classList.add("bg-success");
    } else if (percentage >= 70) {
      progressBar.classList.add("bg-info");
    } else if (percentage >= 30) {
      progressBar.classList.add("bg-warning");
    } else {
      progressBar.classList.add("bg-danger");
    }
  }

  showToast(message, type = "info") {
    // Create toast element
    const toast = document.createElement("div");
    toast.className = `toast align-items-center text-white bg-${type} border-0`;
    toast.setAttribute("role", "alert");
    toast.innerHTML = `
            <div class="d-flex">
                <div class="toast-body">
                    ${message}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        `;

    // Add to page
    let toastContainer = document.querySelector(".toast-container");
    if (!toastContainer) {
      toastContainer = document.createElement("div");
      toastContainer.className =
        "toast-container position-fixed bottom-0 end-0 p-3";
      document.body.appendChild(toastContainer);
    }

    toastContainer.appendChild(toast);

    // Initialize and show toast
    const bsToast = new bootstrap.Toast(toast);
    bsToast.show();

    // Remove element after it's hidden
    toast.addEventListener("hidden.bs.toast", () => {
      toast.remove();
    });
  }

  saveTodos() {
    localStorage.setItem("todos", JSON.stringify(this.todos));
  }

  loadTodos() {
    const saved = localStorage.getItem("todos");
    return saved ? JSON.parse(saved) : [];
  }

  escapeHtml(text) {
    const div = document.createElement("div");
    div.textContent = text;
    return div.innerHTML;
  }

  // Export/Import functionality
  exportTodos() {
    const dataStr = JSON.stringify(this.todos, null, 2);
    const dataBlob = new Blob([dataStr], { type: "application/json" });
    const url = URL.createObjectURL(dataBlob);

    const link = document.createElement("a");
    link.href = url;
    link.download = `todos-${new Date().toISOString().split("T")[0]}.json`;
    link.click();

    URL.revokeObjectURL(url);
    this.showToast("Todos exported successfully!", "success");
  }

  importTodos(file) {
    const reader = new FileReader();
    reader.onload = (e) => {
      try {
        const importedTodos = JSON.parse(e.target.result);
        if (Array.isArray(importedTodos)) {
          this.todos = importedTodos;
          this.saveTodos();
          this.render();
          this.updateCounts();
          this.updateProgress();
          this.showToast("Todos imported successfully!", "success");
        } else {
          throw new Error("Invalid file format");
        }
      } catch (error) {
        this.showToast(
          "Error importing todos. Please check the file format.",
          "danger"
        );
      }
    };
    reader.readAsText(file);
  }

  // Statistics
  getStats() {
    const total = this.todos.length;
    const completed = this.todos.filter((todo) => todo.completed).length;
    const pending = total - completed;
    const highPriority = this.todos.filter(
      (todo) => todo.priority === "high" && !todo.completed
    ).length;

    return {
      total,
      completed,
      pending,
      highPriority,
      completionRate: total === 0 ? 0 : Math.round((completed / total) * 100),
    };
  }
}

// Initialize the app when DOM is loaded
document.addEventListener("DOMContentLoaded", () => {
  window.todoApp = new TodoApp();

  // Add some sample todos for demonstration (only if no todos exist)
  if (window.todoApp.todos.length === 0) {
    const sampleTodos = [
      {
        id: "1",
        text: "Welcome to your Todo Portal! 🎉",
        completed: false,
        priority: "high",
        createdAt: new Date().toISOString(),
        completedAt: null,
      },
      {
        id: "2",
        text: "Try editing this task by clicking the pencil icon",
        completed: false,
        priority: "medium",
        createdAt: new Date(Date.now() - 60000).toISOString(),
        completedAt: null,
      },
      {
        id: "3",
        text: "Mark this task as completed",
        completed: true,
        priority: "low",
        createdAt: new Date(Date.now() - 120000).toISOString(),
        completedAt: new Date().toISOString(),
      },
    ];

    window.todoApp.todos = sampleTodos;
    window.todoApp.saveTodos();
    window.todoApp.render();
    window.todoApp.updateCounts();
    window.todoApp.updateProgress();
  }

  // Focus on input field
  document.getElementById("task-input").focus();

  console.log("Todo Portal loaded successfully! 🚀");
});
