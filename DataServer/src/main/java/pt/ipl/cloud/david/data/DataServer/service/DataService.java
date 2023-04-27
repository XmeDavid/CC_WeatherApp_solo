package pt.ipl.cloud.david.data.DataServer.service;
import pt.ipl.cloud.david.data.DataServer.model.DataEntity;
import pt.ipl.cloud.david.data.DataServer.repository.DataRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class DataService {
    @Autowired
    private DataRepository dataRepository;

    public DataEntity saveData(String content) {
        DataEntity data = new DataEntity();
        data.setContent(content);
        data.setCreatedAt(LocalDateTime.now());
        return dataRepository.save(data);
    }

    public List<DataEntity> findAllData() {
        return dataRepository.findAll();
    }
}
