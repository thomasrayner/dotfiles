function completion_off --description "Disable fish tab completion"
    bind \t self-insert
    echo "🔕 fish completion: OFF"
end
