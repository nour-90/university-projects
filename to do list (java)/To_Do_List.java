package myfirstpjt;
import java.awt.*;
import javax.swing.*;
import java.awt.event.*;

public class To_Do_List implements ActionListener {
	JFrame frame;
    JTextField textField;
    JButton addButton, removeButton, doneButton;
    DefaultListModel<String> model;
    JList<String> todoList;

    public To_Do_List() {

        frame = new JFrame("To Do List");
        frame.setSize(400, 500);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLayout(new BorderLayout());
        frame.getContentPane().setBackground(new Color(230, 220, 250));

        // Top Panel
        JPanel topPanel = new JPanel(new FlowLayout());
        topPanel.setBackground(new Color(230, 220, 250));
        
        JLabel titleLabel = new JLabel("To Do List");
        titleLabel.setFont(new Font("Arial", Font.BOLD, 20));
        titleLabel.setForeground(new Color(120, 80, 200));
        topPanel.add(titleLabel);
        
        textField = new JTextField(15);
        textField.setFont(new Font("Arial", Font.BOLD, 14));

        addButton = new JButton("Add");
        addButton.setBackground(new Color(180, 150, 255));
        addButton.setFont(new Font("Arial", Font.BOLD, 12));
        addButton.addActionListener(this);

        topPanel.add(textField);
        topPanel.add(addButton);

        // Center
        model = new DefaultListModel<>();
        model.addElement("Buy groceries");
        model.addElement("Finish homework");
        model.addElement("Call a friend");

        todoList = new JList<>(model);
        todoList.setBackground(new Color(245, 240, 255));

        JScrollPane scroll = new JScrollPane(todoList);

        // Bottom Panel
        JPanel bottomPanel = new JPanel();
        bottomPanel.setBackground(new Color(230, 220, 250));

        removeButton = new JButton("Remove");
        removeButton.setBackground(new Color(180, 150, 255));
        removeButton.setFont(new Font("Arial", Font.BOLD, 12));
        removeButton.addActionListener(this);

        doneButton = new JButton("Mark as Done");
        doneButton.setBackground(new Color(180, 150, 255));
        doneButton.setFont(new Font("Arial", Font.BOLD, 12));
        doneButton.addActionListener(this);

        bottomPanel.add(removeButton);
        bottomPanel.add(doneButton);

        // Add to Frame
        frame.add(topPanel, BorderLayout.NORTH);
        frame.add(scroll, BorderLayout.CENTER);
        frame.add(bottomPanel, BorderLayout.SOUTH);

        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
         // add function
        if (e.getSource() == addButton) {
            String task = textField.getText().trim();
            if (!task.isEmpty()) {
                model.addElement(task);
                textField.setText("");
            }
        }
        // remove function 
        else if (e.getSource() == removeButton) {
            int index = todoList.getSelectedIndex();
            if (index != -1) {
                model.remove(index);
            }
        }
        // mark as done 
        else if (e.getSource() == doneButton) {
            int index = todoList.getSelectedIndex();
            if (index == -1) return;

            String task = model.getElementAt(index);

            if (!task.contains("Done")) {
                task = "✔ " + task + " (Done)";
            } else {
                task = task.replace("✔ ", "").replace(" (Done)", "");
            }

            model.set(index, task);
        }
    }

    public static void main(String[] args) {
        new To_Do_List();
    }
}