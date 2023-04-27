package pt.ipl.cloud.david.data.DataServer.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pt.ipl.cloud.david.data.DataServer.model.DataEntity;
import pt.ipl.cloud.david.data.DataServer.service.DataService;

import java.util.List;

@RestController
@RequestMapping("/data")
public class DataController {
    @Autowired
    private DataService dataService;

    @PostMapping
    public ResponseEntity<DataEntity> saveData(@RequestBody String content) {
        DataEntity savedData = dataService.saveData(content);
        System.out.println(content);
        System.out.println(savedData);
        return ResponseEntity.created(null).body(savedData);
    }

    @GetMapping
    public ResponseEntity<List<DataEntity>> getAllData() {
        List<DataEntity> data = dataService.findAllData();
        return ResponseEntity.ok(data);
    }
}
